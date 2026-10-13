import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

import 'showcase/gallery_screen.dart';
import 'showcase/theme_editor.dart';
import 'apps/settings_app.dart';
import 'apps/music_app.dart';
import 'apps/file_manager_app.dart';
import 'apps/dashboard_app.dart';

void main() {
  runApp(const SoflumeShowcaseApp());
}

/// Root Showcase & Documentation Application for Soflume UI.
class SoflumeShowcaseApp extends StatefulWidget {
  const SoflumeShowcaseApp({super.key});

  @override
  State<SoflumeShowcaseApp> createState() => _SoflumeShowcaseAppState();
}

class _SoflumeShowcaseAppState extends State<SoflumeShowcaseApp> {
  late SoflumeThemeData _themeData;
  int _activeNavIndex = 0; // 0: Gallery, 1: Theme, 2: Settings, 3: Music, 4: Files, 5: Dashboard

  @override
  void initState() {
    super.initState();
    _themeData = SoflumeThemeData.light();
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeData = isDark
          ? SoflumeThemeData.dark(customAccent: _themeData.colors.accent)
          : SoflumeThemeData.light(customAccent: _themeData.colors.accent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SoflumeTheme(
      data: _themeData,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          color: _themeData.colors.canvas,
          child: SafeArea(
            child: SofAdaptiveBuilder(
              builder: (context, screenClass) {
                final colors = _themeData.colors;
                final typography = _themeData.typography;

                Widget activeScreen;
                switch (_activeNavIndex) {
                  case 0:
                    activeScreen = const GalleryScreen();
                    break;
                  case 1:
                    activeScreen = ThemeEditor(
                      currentTheme: _themeData,
                      onThemeChanged: (newTheme) => setState(() => _themeData = newTheme),
                    );
                    break;
                  case 2:
                    activeScreen = SettingsApp(
                      isDark: _themeData.isDark,
                      onToggleTheme: _toggleTheme,
                    );
                    break;
                  case 3:
                    activeScreen = const MusicApp();
                    break;
                  case 4:
                    activeScreen = const FileManagerApp();
                    break;
                  case 5:
                    activeScreen = const DashboardApp();
                    break;
                  default:
                    activeScreen = const GalleryScreen();
                }

                return Column(
                  children: [
                    // Global Header Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: colors.isDark ? colors.surfaceRaised : colors.surface,
                        border: Border(
                          bottom: BorderSide(color: colors.outlineSubtle, width: 0.8),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Brand Logo & Title
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: colors.accent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors.accent.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'S',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Soflume UI',
                                    style: typography.title.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colors.contentPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    'Soft Lumen Design System',
                                    style: typography.caption.copyWith(
                                      fontSize: 10,
                                      color: colors.contentSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Quick Navigation Tabs (For desktop/tablet)
                          if (!screenClass.isCompact) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 480),
                                  child: SofTabs(
                                    height: 38,
                                    selectedIndex: _activeNavIndex,
                                    onChanged: (idx) => setState(() => _activeNavIndex = idx),
                                    tabs: const [
                                      SofTabItem(label: '组件展馆'),
                                      SofTabItem(label: '主题工坊'),
                                      SofTabItem(label: '设置应用'),
                                      SofTabItem(label: '音乐播放'),
                                      SofTabItem(label: '文件管理'),
                                      SofTabItem(label: '数据看板'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ] else
                            const Spacer(),

                          // Light / Dark Switcher
                          SofIconButton(
                            variant: SofButtonVariant.subtle,
                            icon: Text(
                              _themeData.isDark ? '☀️' : '🌙',
                              style: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () => _toggleTheme(!_themeData.isDark),
                          ),
                        ],
                      ),
                    ),

                    // Active Body View
                    Expanded(child: activeScreen),

                    // Floating Navigation for Mobile
                    if (screenClass.isCompact)
                      SofFloatingNavigation(
                        selectedIndex: _activeNavIndex,
                        onChanged: (idx) => setState(() => _activeNavIndex = idx),
                        items: const [
                          SofNavItem(icon: Text('❖'), label: '展馆'),
                          SofNavItem(icon: Text('🎨'), label: '主题'),
                          SofNavItem(icon: Text('⚙'), label: '设置'),
                          SofNavItem(icon: Text('♪'), label: '音乐'),
                          SofNavItem(icon: Text('📁'), label: '文件'),
                          SofNavItem(icon: Text('📊'), label: '看板'),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
