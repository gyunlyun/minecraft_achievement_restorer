// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的世界成就恢复器';

  @override
  String get appSubtitle => '恢复我的世界基岩版世界中的成就';

  @override
  String get scanningWorlds => '🔍 正在扫描我的世界存档...';

  @override
  String scanningPath(String path) {
    return '正在扫描：$path';
  }

  @override
  String checkingWorld(String worldName) {
    return '正在检查世界：$worldName';
  }

  @override
  String foundWorlds(int count) {
    return '✅ 找到 $count 个世界';
  }

  @override
  String get noWorldsFound => '未找到世界';

  @override
  String get noWorldsFoundDescription => '请先在我的世界中创建一个世界';

  @override
  String get errorScanningWorlds => '扫描世界时出错';

  @override
  String get minecraftNotFound => '未找到我的世界基岩版';

  @override
  String get minecraftNotFoundDescription => '请确保已安装我的世界基岩版（Windows 10版）';

  @override
  String get searchWorlds => '搜索世界...';

  @override
  String get selectAll => '全选';

  @override
  String get clearSelection => '清除选择';

  @override
  String selectedCount(int count) {
    return '已选择 $count 个';
  }

  @override
  String processWorlds(int count) {
    return '处理 $count 个世界';
  }

  @override
  String get confirmProcessing => '⚠️ 确认处理';

  @override
  String confirmProcessingMessage(int count) {
    return '您已选择 $count 个世界进行处理。';
  }

  @override
  String get confirmProcessingWarning => '这将修改 level.dat 文件以恢复成就。';

  @override
  String get confirmProcessingBackup => '💡 建议在继续之前备份您的世界。';

  @override
  String get confirmProcessingQuestion => '您要继续吗？';

  @override
  String get cancel => '取消';

  @override
  String get continueButton => '继续';

  @override
  String get processingWorlds => '正在处理世界';

  @override
  String get startingProcessing => '🚀 开始恢复成就...';

  @override
  String processingWorldCount(int count) {
    return '正在处理 $count 个世界...';
  }

  @override
  String processingWorld(String worldName) {
    return '正在处理：$worldName';
  }

  @override
  String completedWorld(String worldName) {
    return '✅ 已完成：$worldName';
  }

  @override
  String failedWorld(String worldName, String error) {
    return '❌ 失败：$worldName - $error';
  }

  @override
  String allProcessingComplete(int count) {
    return '🎉 成功处理了所有 $count 个世界！';
  }

  @override
  String partialProcessingComplete(int successful, int failed) {
    return '⚠️ 已处理 $successful 个世界，$failed 个失败';
  }

  @override
  String get restartMinecraft => '💡 您现在可以重启我的世界并检查您的成就。';

  @override
  String get refresh => '刷新世界列表';

  @override
  String get close => '关闭';

  @override
  String get ok => '确定';

  @override
  String get error => '错误';

  @override
  String get tryAgain => '重试';

  @override
  String get noWorldsSelected => '未选择世界';

  @override
  String get noWorldsSelectedDescription => '请至少选择一个世界进行处理。';

  @override
  String get worldInvalid => '此世界无法处理（缺少 level.dat）';

  @override
  String createdBackup(String filename) {
    return '已创建备份：$filename';
  }

  @override
  String get modifiedLevelDat => '已修改 level.dat 以恢复成就';

  @override
  String progressOperations(int count) {
    return '进度：已完成 $count 个操作';
  }

  @override
  String get language => '语言';

  @override
  String get settings => '设置';

  @override
  String get switchLanguage => '切换语言';

  @override
  String get languageChangedToEnglish => 'Language changed to English';

  @override
  String get languageChangedToChinese => '语言已切换为中文';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortByName => '按名称排序';

  @override
  String get sortByDate => '按修改时间排序';

  @override
  String get sortAscending => '升序';

  @override
  String get sortDescending => '降序';
}
