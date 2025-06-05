// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Minecraft Achievement Restorer';

  @override
  String get appSubtitle => 'Restore achievements in Minecraft Bedrock worlds';

  @override
  String get scanningWorlds => '🔍 Scanning for Minecraft worlds...';

  @override
  String scanningPath(String path) {
    return 'Scanning: $path';
  }

  @override
  String checkingWorld(String worldName) {
    return 'Checking world: $worldName';
  }

  @override
  String foundWorlds(int count) {
    return '✅ Found $count worlds';
  }

  @override
  String get noWorldsFound => 'No worlds found';

  @override
  String get noWorldsFoundDescription =>
      'Please create a world in Minecraft first';

  @override
  String get errorScanningWorlds => 'Error scanning worlds';

  @override
  String get minecraftNotFound => 'Minecraft Bedrock Edition not found';

  @override
  String get minecraftNotFoundDescription =>
      'Please ensure Minecraft Bedrock Edition (Windows 10 Edition) is installed';

  @override
  String get searchWorlds => 'Search worlds...';

  @override
  String get selectAll => 'Select All';

  @override
  String get clearSelection => 'Clear Selection';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String processWorlds(int count) {
    return 'Process $count World(s)';
  }

  @override
  String get confirmProcessing => '⚠️ Confirm Processing';

  @override
  String confirmProcessingMessage(int count) {
    return 'You have selected $count world(s) for processing.';
  }

  @override
  String get confirmProcessingWarning =>
      'This will modify the level.dat files to restore achievements.';

  @override
  String get confirmProcessingBackup =>
      '💡 It\'s recommended to backup your worlds before proceeding.';

  @override
  String get confirmProcessingQuestion => 'Do you want to continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueButton => 'Continue';

  @override
  String get processingWorlds => 'Processing Worlds';

  @override
  String get startingProcessing => '🚀 Starting achievement restoration...';

  @override
  String processingWorldCount(int count) {
    return 'Processing $count world(s)...';
  }

  @override
  String processingWorld(String worldName) {
    return 'Processing: $worldName';
  }

  @override
  String completedWorld(String worldName) {
    return '✅ Completed: $worldName';
  }

  @override
  String failedWorld(String worldName, String error) {
    return '❌ Failed: $worldName - $error';
  }

  @override
  String allProcessingComplete(int count) {
    return '🎉 Successfully processed all $count world(s)!';
  }

  @override
  String partialProcessingComplete(int successful, int failed) {
    return '⚠️ Processed $successful world(s), $failed failed';
  }

  @override
  String get restartMinecraft =>
      '💡 You can now restart Minecraft and check your achievements.';

  @override
  String get refresh => 'Refresh world list';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noWorldsSelected => 'No worlds selected';

  @override
  String get noWorldsSelectedDescription =>
      'Please select at least one world to process.';

  @override
  String get worldInvalid =>
      'This world cannot be processed (missing level.dat)';

  @override
  String createdBackup(String filename) {
    return 'Created backup: $filename';
  }

  @override
  String get modifiedLevelDat =>
      'Modified level.dat for achievement restoration';

  @override
  String progressOperations(int count) {
    return 'Progress: $count operations completed';
  }

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get languageChangedToEnglish => 'Language changed to English';

  @override
  String get languageChangedToChinese => '语言已切换为中文';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortByName => 'Sort by Name';

  @override
  String get sortByDate => 'Sort by Date';

  @override
  String get sortAscending => 'Ascending';

  @override
  String get sortDescending => 'Descending';
}
