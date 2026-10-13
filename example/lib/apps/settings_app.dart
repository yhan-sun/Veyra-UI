import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// Full interactive Settings App showcasing grouped squircle cards, toggles,
/// sliders, sheets, and adaptive density.
class SettingsApp extends StatefulWidget {
  const SettingsApp({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final ValueChanged<bool> onToggleTheme;

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  bool _airplaneMode = false;
  bool _wifiEnabled = true;
  bool _bluetoothEnabled = true;
  bool _eyeComfort = false;
  bool _hapticFeedback = true;
  double _brightness = 0.75;
  double _volume = 0.6;
  int _appearanceIndex = 0; // 0: Auto, 1: Light, 2: Dark

  @override
  void initState() {
    super.initState();
    _appearanceIndex = widget.isDark ? 2 : 1;
  }

  void _showNetworkSheet() {
    showSofSheet(
      context: context,
      builder: (context) {
        return SofSheet(
          title: const Text('Wi-Fi Networks'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SofListTile(
                title: const Text('Soflume-5G-Pro'),
                subtitle: const Text('Connected • Signal Strong'),
                trailing: const SofBadge(label: Text('Connected'), variant: SofBadgeVariant.success),
              ),
              const SizedBox(height: 8),
              SofListTile(
                title: const Text('OriginOS-Office-Guest'),
                subtitle: const Text('Available'),
                showChevron: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              SofListTile(
                title: const Text('Harmony-Mesh-WiFi'),
                subtitle: const Text('Secured'),
                showChevron: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              SofButton(
                variant: SofButtonVariant.subtle,
                fullWidth: true,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settings',
                style: typography.display.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.contentPrimary,
                ),
              ),
              SofBadge(
                label: const Text('v1.0'),
                variant: SofBadgeVariant.accent,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // User Profile Card
          SofCard(
            variant: SofSurfaceVariant.ambient,
            padding: const EdgeInsets.all(16),
            onPressed: () {
              showSofToast(
                context: context,
                message: 'Viewing Sofia Lumen profile',
                variant: SofBadgeVariant.accent,
              );
            },
            child: Row(
              children: [
                const SofAvatar(
                  initials: 'SL',
                  size: 54,
                  statusColor: Color(0xFF258867),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sofia Lumen',
                        style: typography.title.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.contentPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Apple ID, iCloud+ & Subscriptions',
                        style: typography.caption.copyWith(
                          color: colors.contentSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  size: const Size(8, 14),
                  painter: _SettingsChevron(color: colors.contentSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Connectivity Group
          _buildSectionHeader('CONNECTIVITY'),
          SofCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SofListTile(
                  leading: _buildIconCircle(const Text('✈', style: TextStyle(fontSize: 14)), const Color(0xFFFF9500)),
                  title: const Text('Airplane Mode'),
                  trailing: SofToggle(
                    value: _airplaneMode,
                    onChanged: (val) => setState(() => _airplaneMode = val),
                  ),
                ),
                _buildDivider(),
                SofListTile(
                  leading: _buildIconCircle(const Text('📶', style: TextStyle(fontSize: 14)), const Color(0xFF34C759)),
                  title: const Text('Wi-Fi'),
                  subtitle: Text(_wifiEnabled ? 'Soflume-5G-Pro' : 'Off'),
                  showChevron: true,
                  onPressed: _showNetworkSheet,
                ),
                _buildDivider(),
                SofListTile(
                  leading: _buildIconCircle(const Text('ᛒ', style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF))), const Color(0xFF007AFF)),
                  title: const Text('Bluetooth'),
                  trailing: SofToggle(
                    value: _bluetoothEnabled,
                    luminous: true,
                    onChanged: (val) => setState(() => _bluetoothEnabled = val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Display & Brightness Group
          _buildSectionHeader('DISPLAY & BRIGHTNESS'),
          SofCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: typography.label.copyWith(color: colors.contentSecondary),
                ),
                const SizedBox(height: 10),
                SofSegmentedControl<int>(
                  value: _appearanceIndex,
                  onChanged: (index) {
                    setState(() => _appearanceIndex = index);
                    if (index == 1) widget.onToggleTheme(false);
                    if (index == 2) widget.onToggleTheme(true);
                  },
                  segments: const [
                    SofSegment(value: 0, label: Text('Auto')),
                    SofSegment(value: 1, label: Text('Light')),
                    SofSegment(value: 2, label: Text('Dark')),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Brightness',
                  style: typography.label.copyWith(color: colors.contentSecondary),
                ),
                const SizedBox(height: 6),
                SofSlider(
                  value: _brightness,
                  luminous: true,
                  onChanged: (val) => setState(() => _brightness = val),
                ),
                const SizedBox(height: 14),
                SofListTile(
                  padding: EdgeInsets.zero,
                  title: const Text('Eye Comfort (Luminous)'),
                  subtitle: const Text('Reduces blue light radiation'),
                  trailing: SofToggle(
                    value: _eyeComfort,
                    luminous: true,
                    onChanged: (val) => setState(() => _eyeComfort = val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sound & Volume Group
          _buildSectionHeader('SOUND & HAPTICS'),
          SofCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volume',
                  style: typography.label.copyWith(color: colors.contentSecondary),
                ),
                const SizedBox(height: 6),
                SofSlider(
                  value: _volume,
                  onChanged: (val) => setState(() => _volume = val),
                ),
                const SizedBox(height: 12),
                SofListTile(
                  padding: EdgeInsets.zero,
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Tactile physical vibration response'),
                  trailing: SofToggle(
                    value: _hapticFeedback,
                    onChanged: (val) => setState(() => _hapticFeedback = val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Storage Breakdown
          _buildSectionHeader('STORAGE'),
          SofCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('iPhone Storage', style: typography.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('112 GB of 256 GB Used', style: typography.caption),
                  ],
                ),
                const SizedBox(height: 12),
                const SofProgress(
                  value: 0.44,
                  luminous: true,
                  trackHeight: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Danger Action
          Center(
            child: SofButton(
              variant: SofButtonVariant.danger,
              onPressed: () {
                showSofDialog(
                  context: context,
                  builder: (context) {
                    return SofDialog(
                      title: const Text('Reset All Settings?'),
                      actions: [
                        SofButton(
                          variant: SofButtonVariant.ghost,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        SofButton(
                          variant: SofButtonVariant.danger,
                          onPressed: () {
                            Navigator.of(context).pop();
                            showSofToast(
                              context: context,
                              message: 'All settings reset to defaults',
                              variant: SofBadgeVariant.danger,
                            );
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                      child: const Text(
                        'This will restore all network configurations, display preferences, and notifications to factory defaults. No user data will be deleted.',
                      ),
                    );
                  },
                );
              },
              child: const Text('Reset All Settings'),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: SoflumeTheme.colorsOf(context).contentSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    final colors = SoflumeTheme.colorsOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: 54),
      child: Container(
        height: 0.8,
        color: colors.outlineSubtle,
      ),
    );
  }

  Widget _buildIconCircle(Widget icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }
}

class _SettingsChevron extends CustomPainter {
  const _SettingsChevron({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(1.5, 1.5);
    path.lineTo(size.width - 1.5, size.height / 2);
    path.lineTo(1.5, size.height - 1.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SettingsChevron oldDelegate) => false;
}
