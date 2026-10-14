import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

import '../apps/settings_app.dart';
import '../apps/music_app.dart';
import '../apps/file_manager_app.dart';
import '../apps/dashboard_app.dart';

/// 旗舰场景演示平台：集成系统设置、音乐播放器、文件管理与数据看板
class DemosScreen extends StatefulWidget {
  const DemosScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final ValueChanged<bool> onToggleTheme;

  @override
  State<DemosScreen> createState() => _DemosScreenState();
}

class _DemosScreenState extends State<DemosScreen> {
  int _activeAppIndex = 0; // 0: Settings, 1: Music, 2: Files, 3: Dashboard

  @override
  void initState() {
    super.initState();
    final app = Uri.base.queryParameters['app'];
    if (app == 'music' || app == '1') {
      _activeAppIndex = 1;
    } else if (app == 'files' || app == '2') {
      _activeAppIndex = 2;
    } else if (app == 'dashboard' || app == '3') {
      _activeAppIndex = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    Widget activeAppWidget;
    switch (_activeAppIndex) {
      case 0:
        activeAppWidget = SettingsApp(
          isDark: widget.isDark,
          onToggleTheme: widget.onToggleTheme,
        );
        break;
      case 1:
        activeAppWidget = const MusicApp();
        break;
      case 2:
        activeAppWidget = const FileManagerApp();
        break;
      case 3:
      default:
        activeAppWidget = const DashboardApp();
        break;
    }

    return Column(
      children: [
        // 场景应用切换栏
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: colors.isDark ? colors.surfaceRaised : colors.surface,
            border: Border(bottom: BorderSide(color: colors.outlineSubtle, width: 0.8)),
          ),
          child: Row(
            children: [
              Text(
                '场景演示',
                style: typography.caption.copyWith(fontWeight: FontWeight.w700, color: colors.contentSecondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: SofTabs(
                      height: 36,
                      selectedIndex: _activeAppIndex,
                      onChanged: (idx) => setState(() => _activeAppIndex = idx),
                      tabs: const [
                        SofTabItem(label: '系统设置'),
                        SofTabItem(label: '音乐播放'),
                        SofTabItem(label: '文件管理'),
                        SofTabItem(label: '数据看板'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 演示应用内容视口
        Expanded(child: activeAppWidget),
      ],
    );
  }
}
