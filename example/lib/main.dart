import 'dart:ui' as ui;
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
    final params = Uri.base.queryParameters;
    final isDark = params['theme'] == 'dark';
    _themeData = isDark ? SoflumeThemeData.dark() : SoflumeThemeData.light();
    if (params.containsKey('tab')) {
      final tabIdx = int.tryParse(params['tab'] ?? '');
      if (tabIdx != null && tabIdx >= 0 && tabIdx <= 4) {
        _activeNavIndex = tabIdx;
      }
    }
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
                    onNavigateToDemos: () => setState(() => _activeNavIndex = 4),
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
                  // Flagship Frosted Glass Header Bar
                  ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: colors.isDark ? const Color(0xD40B0D14) : const Color(0xE6FFFFFF),
                          border: Border(
                            bottom: BorderSide(
                              color: colors.isDark ? const Color(0x18FFFFFF) : const Color(0x0F000000),
                              width: 0.8,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Brand Logo & Title with Gradient Squircle
                            Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'S',
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 19,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Soflume UI',
                                          style: typography.title.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: colors.contentPrimary,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: colors.accent.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'v1.0',
                                            style: typography.caption.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: colors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Soft Lumen Design System v1.0',
                                      style: typography.caption.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
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

                            // Actions: GitHub Link & Theme Switcher
                            if (!screenClass.isCompact) ...[
                              SofButton(
                                variant: SofButtonVariant.ghost,
                                size: SofButtonSize.small,
                                leading: SofIcon(SofIcons.github, size: 16, color: colors.contentPrimary),
                                onPressed: () {
                                  showSofToast(
                                    context: context,
                                    message: 'GitHub: yhan-sun/Veyra-UI',
                                    variant: SofBadgeVariant.accent,
                                  );
                                },
                                child: const Text('GitHub'),
                              ),
                              const SizedBox(width: 8),
                            ],
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
