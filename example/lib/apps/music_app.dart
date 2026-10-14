import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// 标杆应用：沉浸式旗舰音乐播放器 (Music App)
///
/// 特性：
/// - 沉浸式动态光晕背景（根据当前曲目动态演变柔光）。
/// - G2 超椭圆封面、高透光泽与细腻微交互。
/// - 状态指示胶囊（空间音频与输出设备状态）。
/// - 真实可拖拽时间轴进度条与双端时间戳。
/// - 原生调和弹簧播放/暂停变形按键。
/// - 交互式待播队列底板与设备切换。
class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool _isPlaying = true;
  double _playbackPosition = 0.38; // ~1:26 of 3:45
  bool _isLiked = true;
  bool _isShuffle = false;
  bool _isRepeat = true;
  int _activeTrackIndex = 0;
  double _volume = 0.75;

  final List<Map<String, dynamic>> _playlist = [
    {
      'title': 'Luminous Waves',
      'artist': 'Soflume Symphony Orchestra',
      'album': 'Soft Lumen Odyssey 2026',
      'duration': '3:45',
      'color': const Color(0xFF6366F1),
      'badge': 'Hi-Res Lossless 24-bit',
      'svg': SofIcons.activity,
    },
    {
      'title': 'Midnight Superellipse',
      'artist': 'Origin Acoustic Lab',
      'album': 'Continuous Curvature Vol.1',
      'duration': '4:12',
      'color': const Color(0xFF0EA5E9),
      'badge': 'Master Lossless',
      'svg': SofIcons.moon,
    },
    {
      'title': 'Harmonic Resonance',
      'artist': 'ColorOS Soundscapes',
      'album': 'Dynamic Optics',
      'duration': '3:18',
      'color': const Color(0xFF10B981),
      'badge': 'Dolby Atmos 空间音频',
      'svg': SofIcons.sparkles,
    },
    {
      'title': 'Spring Oscillation',
      'artist': 'Hyper Physical Beats',
      'album': 'Damped Dynamics',
      'duration': '2:55',
      'color': const Color(0xFFF59E0B),
      'badge': 'Spatial Audio',
      'svg': SofIcons.zap,
    },
  ];

  Map<String, dynamic> get _currentTrack => _playlist[_activeTrackIndex];

  String _formatTime(double fraction) {
    final totalSeconds = (fraction * 225).round();
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  void _showQueueSheet() {
    showSofSheet(
      context: context,
      builder: (context) {
        return SofSheet(
          title: const Text('播放队列 Up Next'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(_playlist.length, (index) {
                final track = _playlist[index];
                final isCurrent = index == _activeTrackIndex;
                final trackColor = track['color'] as Color;

                return SofListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: trackColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: SofIcon(
                      track['svg'] as String,
                      size: 20,
                      color: trackColor,
                    ),
                  ),
                  title: Text(
                    track['title'] as String,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? trackColor : null,
                    ),
                  ),
                  subtitle: Text('${track['artist']} • ${track['badge']}'),
                  trailing: isCurrent
                      ? const SofBadge(label: Text('播放中'), variant: SofBadgeVariant.accent)
                      : Text(track['duration'] as String),
                  onPressed: () {
                    setState(() {
                      _activeTrackIndex = index;
                      _playbackPosition = 0.0;
                      _isPlaying = true;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
              const SizedBox(height: 18),
              SofButton(
                variant: SofButtonVariant.subtle,
                fullWidth: true,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭队列'),
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
    final radii = theme.radii;
    final track = _currentTrack;
    final themeAccent = track['color'] as Color;

    return Stack(
      children: [
        // Immersive Diffuse Dynamic Ambient Aura
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.4),
                radius: 1.2,
                colors: [
                  themeAccent.withValues(alpha: colors.isDark ? 0.22 : 0.14),
                  colors.isDark ? const Color(0xFF0B0D14) : const Color(0xFFF8FAFC),
                ],
              ),
            ),
          ),
        ),

        // Scrollable Player Body
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Device & Queue Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.isDark ? const Color(0x30FFFFFF) : const Color(0x10000000),
                          borderRadius: BorderRadius.circular(radii.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10B981))),
                            const SizedBox(width: 6),
                            Text('AirPods Pro • 杜比空间音频', style: typography.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
                          ],
                        ),
                      ),
                      SofIconButton(
                        variant: SofButtonVariant.ghost,
                        icon: const SofIcon(SofIcons.list, size: 20),
                        onPressed: _showQueueSheet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 3D / Album Art Squircle Container with Optical Sheen
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          themeAccent,
                          Color.lerp(themeAccent, const Color(0xFF000000), 0.35)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(radii.xxl),
                      boxShadow: [
                        BoxShadow(
                          color: themeAccent.withValues(alpha: colors.isDark ? 0.45 : 0.30),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                          spreadRadius: -4,
                        ),
                        const BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Subtle Concentric Vinyl Grooves
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0x18FFFFFF), width: 1.5),
                          ),
                        ),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0x22FFFFFF), width: 1.5),
                          ),
                        ),
                        // Center Centerpiece Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x33FFFFFF),
                          ),
                          alignment: Alignment.center,
                          child: SofIcon(track['svg'] as String, size: 38, color: const Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Title, Artist, & Like Button Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track['title'] as String,
                              style: typography.display.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: colors.contentPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${track['artist']} • ${track['album']}',
                              style: typography.body.copyWith(
                                color: colors.contentSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SofIconButton(
                        variant: SofButtonVariant.subtle,
                        icon: SofIcon(
                          SofIcons.star,
                          size: 20,
                          color: _isLiked ? const Color(0xFFF59E0B) : colors.contentSecondary,
                        ),
                        onPressed: () {
                          setState(() => _isLiked = !_isLiked);
                          showSofToast(
                            context: context,
                            message: _isLiked ? '已添加到喜爱列表' : '已移出喜爱列表',
                            variant: SofBadgeVariant.accent,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Audio Quality Tag Pill
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: themeAccent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          track['badge'] as String,
                          style: typography.caption.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: themeAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'FLAC 192kHz • 动态头部追踪',
                        style: typography.caption.copyWith(fontSize: 11, color: colors.contentTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Real-time Scrubbing Slider
                  SofSlider(
                    value: _playbackPosition,
                    onChanged: (val) => setState(() => _playbackPosition = val),
                    luminous: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(_playbackPosition),
                          style: typography.caption.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: colors.contentSecondary),
                        ),
                        Text(
                          track['duration'] as String,
                          style: typography.caption.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: colors.contentTertiary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Transport Controls (Shuffle, Prev, Giant Play/Pause, Next, Repeat)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SofIconButton(
                        variant: _isShuffle ? SofButtonVariant.subtle : SofButtonVariant.ghost,
                        icon: SofIcon(SofIcons.shuffle, size: 20, color: _isShuffle ? themeAccent : colors.contentSecondary),
                        onPressed: () {
                          setState(() => _isShuffle = !_isShuffle);
                          showSofToast(context: context, message: _isShuffle ? '随机播放开启' : '顺序播放开启');
                        },
                      ),
                      SofIconButton(
                        variant: SofButtonVariant.ghost,
                        icon: const SofIcon(SofIcons.skipBack, size: 24),
                        onPressed: () {
                          setState(() {
                            _activeTrackIndex = (_activeTrackIndex - 1 + _playlist.length) % _playlist.length;
                            _playbackPosition = 0.0;
                          });
                        },
                      ),
                      // Giant Center Play/Pause Spring Button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeAccent.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [themeAccent, Color.lerp(themeAccent, const Color(0xFF000000), 0.25)!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: SofIcon(
                              _isPlaying ? SofIcons.pause : SofIcons.play,
                              size: 26,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      SofIconButton(
                        variant: SofButtonVariant.ghost,
                        icon: const SofIcon(SofIcons.skipForward, size: 24),
                        onPressed: () {
                          setState(() {
                            _activeTrackIndex = (_activeTrackIndex + 1) % _playlist.length;
                            _playbackPosition = 0.0;
                          });
                        },
                      ),
                      SofIconButton(
                        variant: _isRepeat ? SofButtonVariant.subtle : SofButtonVariant.ghost,
                        icon: SofIcon(SofIcons.repeat, size: 20, color: _isRepeat ? themeAccent : colors.contentSecondary),
                        onPressed: () {
                          setState(() => _isRepeat = !_isRepeat);
                          showSofToast(context: context, message: _isRepeat ? '列表循环开启' : '单曲单次');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Volume Slider Card
                  Row(
                    children: [
                      const SofIcon(SofIcons.volume, size: 18),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SofSlider(
                          value: _volume,
                          onChanged: (v) => setState(() => _volume = v),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text('${(_volume * 100).round()}%',
                          style: typography.caption.copyWith(fontWeight: FontWeight.w700, color: colors.contentSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
