import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Minecraft Achievement Restorer'**
  String get appTitle;

  /// Subtitle describing the app's purpose
  ///
  /// In en, this message translates to:
  /// **'Restore achievements in Minecraft Bedrock worlds'**
  String get appSubtitle;

  /// Message shown when scanning for worlds
  ///
  /// In en, this message translates to:
  /// **'🔍 Scanning for Minecraft worlds...'**
  String get scanningWorlds;

  /// Message showing current scanning path
  ///
  /// In en, this message translates to:
  /// **'Scanning: {path}'**
  String scanningPath(String path);

  /// Message when checking a specific world
  ///
  /// In en, this message translates to:
  /// **'Checking world: {worldName}'**
  String checkingWorld(String worldName);

  /// Message showing number of worlds found
  ///
  /// In en, this message translates to:
  /// **'✅ Found {count} worlds'**
  String foundWorlds(int count);

  /// Message when no worlds are found
  ///
  /// In en, this message translates to:
  /// **'No worlds found'**
  String get noWorldsFound;

  /// Description when no worlds are found
  ///
  /// In en, this message translates to:
  /// **'Please create a world in Minecraft first'**
  String get noWorldsFoundDescription;

  /// Error message when scanning fails
  ///
  /// In en, this message translates to:
  /// **'Error scanning worlds'**
  String get errorScanningWorlds;

  /// Error when Minecraft is not installed
  ///
  /// In en, this message translates to:
  /// **'Minecraft Bedrock Edition not found'**
  String get minecraftNotFound;

  /// Description for Minecraft not found error
  ///
  /// In en, this message translates to:
  /// **'Please ensure Minecraft Bedrock Edition (Windows 10 Edition) is installed'**
  String get minecraftNotFoundDescription;

  /// Placeholder text for world search field
  ///
  /// In en, this message translates to:
  /// **'Search worlds...'**
  String get searchWorlds;

  /// Button to select all worlds
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// Button to clear world selection
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// Shows number of selected worlds
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// Button text for processing worlds
  ///
  /// In en, this message translates to:
  /// **'Process {count} World(s)'**
  String processWorlds(int count);

  /// Title for confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'⚠️ Confirm Processing'**
  String get confirmProcessing;

  /// Confirmation message
  ///
  /// In en, this message translates to:
  /// **'You have selected {count} world(s) for processing.'**
  String confirmProcessingMessage(int count);

  /// Warning about file modification
  ///
  /// In en, this message translates to:
  /// **'This will modify the level.dat files to restore achievements.'**
  String get confirmProcessingWarning;

  /// Backup recommendation
  ///
  /// In en, this message translates to:
  /// **'💡 It\'s recommended to backup your worlds before proceeding.'**
  String get confirmProcessingBackup;

  /// Confirmation question
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue?'**
  String get confirmProcessingQuestion;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Title for processing dialog
  ///
  /// In en, this message translates to:
  /// **'Processing Worlds'**
  String get processingWorlds;

  /// Message when starting processing
  ///
  /// In en, this message translates to:
  /// **'🚀 Starting achievement restoration...'**
  String get startingProcessing;

  /// Message showing processing count
  ///
  /// In en, this message translates to:
  /// **'Processing {count} world(s)...'**
  String processingWorldCount(int count);

  /// Message when processing specific world
  ///
  /// In en, this message translates to:
  /// **'Processing: {worldName}'**
  String processingWorld(String worldName);

  /// Message when world processing completed
  ///
  /// In en, this message translates to:
  /// **'✅ Completed: {worldName}'**
  String completedWorld(String worldName);

  /// Message when world processing failed
  ///
  /// In en, this message translates to:
  /// **'❌ Failed: {worldName} - {error}'**
  String failedWorld(String worldName, String error);

  /// Message when all processing completed successfully
  ///
  /// In en, this message translates to:
  /// **'🎉 Successfully processed all {count} world(s)!'**
  String allProcessingComplete(int count);

  /// Message when some processing failed
  ///
  /// In en, this message translates to:
  /// **'⚠️ Processed {successful} world(s), {failed} failed'**
  String partialProcessingComplete(int successful, int failed);

  /// Message about restarting Minecraft
  ///
  /// In en, this message translates to:
  /// **'💡 You can now restart Minecraft and check your achievements.'**
  String get restartMinecraft;

  /// Tooltip for refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh world list'**
  String get refresh;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Error when no worlds are selected
  ///
  /// In en, this message translates to:
  /// **'No worlds selected'**
  String get noWorldsSelected;

  /// Description for no worlds selected error
  ///
  /// In en, this message translates to:
  /// **'Please select at least one world to process.'**
  String get noWorldsSelectedDescription;

  /// Message for invalid worlds
  ///
  /// In en, this message translates to:
  /// **'This world cannot be processed (missing level.dat)'**
  String get worldInvalid;

  /// Message when backup is created
  ///
  /// In en, this message translates to:
  /// **'Created backup: {filename}'**
  String createdBackup(String filename);

  /// Message when level.dat is modified
  ///
  /// In en, this message translates to:
  /// **'Modified level.dat for achievement restoration'**
  String get modifiedLevelDat;

  /// Progress counter in dialog
  ///
  /// In en, this message translates to:
  /// **'Progress: {count} operations completed'**
  String progressOperations(int count);

  /// Language menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language switch menu item
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// Message when language is changed to English
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChangedToEnglish;

  /// Message when language is changed to Chinese
  ///
  /// In en, this message translates to:
  /// **'语言已切换为中文'**
  String get languageChangedToChinese;

  /// Sort options label
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Sort by world name option
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortByName;

  /// Sort by last modified date option
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// Ascending sort order
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sortAscending;

  /// Descending sort order
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sortDescending;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
