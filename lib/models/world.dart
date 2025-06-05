import 'dart:io';
import 'package:path/path.dart' as p;

/// Represents a Minecraft Bedrock world
class World {
  final String name;
  final String path;
  final DateTime? lastModified;
  final int? sizeBytes;
  final bool hasLevelDat;

  World({
    required this.name,
    required this.path,
    this.lastModified,
    this.sizeBytes,
    this.hasLevelDat = false,
  });

  /// Get display name for the world
  String getDisplayName() {
    return name.isNotEmpty ? name : path.split(Platform.pathSeparator).last;
  }

  /// Get details text for the world
  String getDetailsText() {
    final details = <String>[];
    
    if (lastModified != null) {
      details.add('Modified: ${_formatDate(lastModified!)}');
    }
    
    if (sizeBytes != null) {
      details.add('Size: ${_formatFileSize(sizeBytes!)}');
    }
    
    details.add('Path: $path');
    
    if (!hasLevelDat) {
      details.add('⚠️ No level.dat found');
    }
    
    return details.join(' • ');
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Check if the world is valid for processing
  bool isValid() {
    return hasLevelDat && Directory(path).existsSync();
  }

  /// Create World from directory
  static Future<World?> fromDirectory(String worldPath) async {
    try {
      final dir = Directory(worldPath);
      if (!dir.existsSync()) return null;

      final levelDatFile = File(p.join(worldPath, 'level.dat'));
      final hasLevelDat = levelDatFile.existsSync();

      // Try to get world name from levelname.txt
      String worldName = p.basename(worldPath);
      final levelNameFile = File(p.join(worldPath, 'levelname.txt'));
      if (levelNameFile.existsSync()) {
        try {
          worldName = await levelNameFile.readAsString();
          worldName = worldName.trim();
        } catch (e) {
          // Use directory name as fallback
        }
      }

      // Get directory stats
      final stat = dir.statSync();
      int? totalSize;
      try {
        totalSize = await _calculateDirectorySize(dir);
      } catch (e) {
        // Size calculation failed, continue without it
      }

      return World(
        name: worldName,
        path: worldPath,
        lastModified: stat.modified,
        sizeBytes: totalSize,
        hasLevelDat: hasLevelDat,
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate total size of directory
  static Future<int> _calculateDirectorySize(Directory dir) async {
    int totalSize = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        try {
          final stat = entity.statSync();
          totalSize += stat.size;
        } catch (e) {
          // Skip files that can't be accessed
        }
      }
    }
    return totalSize;
  }

  @override
  String toString() {
    return 'World(name: $name, path: $path, hasLevelDat: $hasLevelDat)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is World && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}
