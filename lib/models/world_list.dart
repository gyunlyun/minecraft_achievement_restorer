import 'world.dart';

/// Container for a list of Minecraft worlds
class WorldList {
  final List<World> worlds;

  WorldList(this.worlds);

  /// Get the number of worlds
  int get length => worlds.length;

  /// Alternative getter for compatibility with Go version
  int len() => length;

  /// Check if the list is empty
  bool get isEmpty => worlds.isEmpty;

  /// Check if the list is not empty
  bool get isNotEmpty => worlds.isNotEmpty;

  /// Get world at index
  World operator [](int index) => worlds[index];

  /// Get all valid worlds (have level.dat)
  List<World> get validWorlds => worlds.where((world) => world.isValid()).toList();

  /// Get all invalid worlds (missing level.dat or inaccessible)
  List<World> get invalidWorlds => worlds.where((world) => !world.isValid()).toList();

  /// Add a world to the list
  void add(World world) {
    worlds.add(world);
  }

  /// Remove a world from the list
  bool remove(World world) {
    return worlds.remove(world);
  }

  /// Clear all worlds
  void clear() {
    worlds.clear();
  }

  /// Sort worlds by name
  void sortByName({bool ascending = true}) {
    worlds.sort((a, b) {
      final comparison = a.getDisplayName().toLowerCase().compareTo(b.getDisplayName().toLowerCase());
      return ascending ? comparison : -comparison;
    });
  }

  /// Sort worlds by last modified date
  void sortByDate({bool ascending = false}) {
    worlds.sort((a, b) {
      if (a.lastModified == null && b.lastModified == null) return 0;
      if (a.lastModified == null) return ascending ? 1 : -1;
      if (b.lastModified == null) return ascending ? -1 : 1;
      final comparison = a.lastModified!.compareTo(b.lastModified!);
      return ascending ? comparison : -comparison;
    });
  }

  /// Create a sorted copy of the world list
  WorldList sortedByName({bool ascending = true}) {
    final sortedWorlds = List<World>.from(worlds);
    sortedWorlds.sort((a, b) {
      final comparison = a.getDisplayName().toLowerCase().compareTo(b.getDisplayName().toLowerCase());
      return ascending ? comparison : -comparison;
    });
    return WorldList(sortedWorlds);
  }

  /// Create a sorted copy of the world list by date
  WorldList sortedByDate({bool ascending = false}) {
    final sortedWorlds = List<World>.from(worlds);
    sortedWorlds.sort((a, b) {
      if (a.lastModified == null && b.lastModified == null) return 0;
      if (a.lastModified == null) return ascending ? 1 : -1;
      if (b.lastModified == null) return ascending ? -1 : 1;
      final comparison = a.lastModified!.compareTo(b.lastModified!);
      return ascending ? comparison : -comparison;
    });
    return WorldList(sortedWorlds);
  }

  /// Filter worlds by name
  WorldList filterByName(String query) {
    if (query.isEmpty) return WorldList(List.from(worlds));
    
    final filtered = worlds.where((world) =>
        world.getDisplayName().toLowerCase().contains(query.toLowerCase())).toList();
    return WorldList(filtered);
  }

  /// Get summary statistics
  Map<String, dynamic> getStats() {
    return {
      'total': length,
      'valid': validWorlds.length,
      'invalid': invalidWorlds.length,
      'totalSize': worlds.fold<int>(0, (sum, world) => sum + (world.sizeBytes ?? 0)),
    };
  }

  @override
  String toString() {
    return 'WorldList(${worlds.length} worlds)';
  }
}
