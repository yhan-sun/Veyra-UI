import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

import 'showcase/overview_screen.dart';
import 'showcase/design_system_screen.dart';
import 'showcase/components_screen.dart';
import 'showcase/theme_editor.dart';
import 'showcase/demos_screen.dart';

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
  int _activeNavIndex = 0; // 0: 概览, 1: 规范, 2: 组件, 3: 主题, 4: 演示

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
    return SoflumeApp(
      title: 'Soflume UI — Soft Lumen 柔光设计系统',
      theme: _themeData,
      home: Container(
        color: _themeData.colors.canvas,
        child: SafeArea(
          child: SofAdaptiveBuilder(
            builder: (context, screenClass) {
              final colors = _themeData.colors;
              final typography = _themeData.typography;

              Widget activeScreen;
              switch (_activeNavIndex) {
                case 0:
                  activeScreen = OverviewScreen(
                    onNavigateToComponents: () => setState(() => _activeNavIndex = 2),
                  );
                  break;
                case 1:
                  activeScreen = const DesignSystemScreen();
                  break;
                case 2:
                  activeScreen = const ComponentsScreen();
                  break;
                case 3:
                  activeScreen = ThemeEditor(
                    currentTheme: _themeData,
                    onThemeChanged: (newTheme) => setState(() => _themeData = newTheme),
                  );
                  break;
                case 4:
                  activeScreen = DemosScreen(
                    isDark: _themeData.isDark,
                    onToggleTheme: _toggleTheme,
                  );
                  break;
                default:
                  activeScreen = OverviewScreen(
                    onNavigateToComponents: () => setState(() => _activeNavIndex = 2),
                  );
              }

              return Column(
                children: [
                  // Global Header Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                          const SizedBox(width: 24),
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 520),
                                child: SofTabs(
                                  height: 38,
                                  selectedIndex: _activeNavIndex,
                                  onChanged: (idx) => setState(() => _activeNavIndex = idx),
                                  tabs: const [
                                    SofTabItem(label: '系统概览'),
                                    SofTabItem(label: '设计规范'),
                                    SofTabItem(label: '组件展馆'),
                                    SofTabItem(label: '主题工坊'),
                                    SofTabItem(label: '场景演示'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ] else
                          const Spacer(),

                        // Light / Dark Switcher
                        SofIconButton(
                          variant: SofButtonVariant.subtle,
                          icon: SofIcon(
                            _themeData.isDark ? SofIcons.sun : SofIcons.moon,
                            size: 18,
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
                        SofNavItem(icon: SofIcon(SofIcons.activity, size: 18), label: '概览'),
                        SofNavItem(icon: SofIcon(SofIcons.ruler, size: 18), label: '规范'),
                        SofNavItem(icon: SofIcon(SofIcons.component, size: 18), label: '组件'),
                        SofNavItem(icon: SofIcon(SofIcons.palette, size: 18), label: '主题'),
                        SofNavItem(icon: SofIcon(SofIcons.layout, size: 18), label: '演示'),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
