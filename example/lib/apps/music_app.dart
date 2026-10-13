import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// Full interactive Music App with Soft Lumen ambient optics,
/// live status capsule, playback scrubbing, and playlist management.
class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool _isPlaying = true;
  double _playbackPosition = 0.42; // ~1:35 of 3:45
  bool _isLiked = true;
  bool _isShuffle = false;
  int _activeTrackIndex = 0;

  final List<Map<String, dynamic>> _playlist = [
    {
      'title': 'Luminous Waves',
      'artist': 'Soflume Symphony',
      'duration': '3:45',
      'svg': SofIcons.activity,
      'color': const Color(0xFF5362E8),
    },
    {
      'title': 'Midnight Superellipse',
      'artist': 'Origin Sound',
      'duration': '4:12',
      'svg': SofIcons.moon,
      'color': const Color(0xFF9EA8FF),
    },
    {
      'title': 'Continuous Curvature',
      'artist': 'Harmonic Beats',
      'duration': '3:18',
      'svg': SofIcons.sparkles,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'Spring Oscillation',
      'artist': 'Physics Lab',
      'duration': '2:55',
      'svg': SofIcons.zap,
      'color': const Color(0xFFF79009),
    },
  ];

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
          title: const Text('Up Next in Queue'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(_playlist.length, (index) {
                final track = _playlist[index];
                final isCurrent = index == _activeTrackIndex;
                return SofListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: SoflumeTheme.colorsOf(context).surfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: SofIcon(
                      track['svg'] as String,
                      size: 20,
                      color: track['color'] as Color,
                    ),
                  ),
                  title: Text(track['title']!),
                  subtitle: Text(track['artist']!),
                  trailing: isCurrent
                      ? const SofBadge(label: Text('Playing'), variant: SofBadgeVariant.accent)
                      : Text(track['duration']!),
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
              const SizedBox(height: 16),
              SofButton(
                variant: SofButtonVariant.subtle,
                fullWidth: true,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close Queue'),
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
    final currentTrack = _playlist[_activeTrackIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Live Status Capsule at top
          SofLiveCapsule(
            leading: SofIcon(
              _isPlaying ? SofIcons.play : SofIcons.pause,
              color: colors.accent,
              size: 14,
            ),
            title: Text('${currentTrack['title']} • ${currentTrack['artist']}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _formatTime(_playbackPosition),
                style: typography.caption.copyWith(
                  color: colors.accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            expandedChild: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SofButton(
                  size: SofButtonSize.small,
                  variant: SofButtonVariant.ghost,
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  child: Text(_isPlaying ? 'Pause' : 'Play'),
                ),
                SofButton(
                  size: SofButtonSize.small,
                  variant: SofButtonVariant.subtle,
                  onPressed: _showQueueSheet,
                  child: const Text('View Queue'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Luminous Album Cover Art
          Center(
            child: SofSurface(
              variant: SofSurfaceVariant.ambient,
              borderRadius: BorderRadius.circular(32),
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.accent,
                          colors.accent.withValues(alpha: 0.6),
                          colors.isDark ? const Color(0xFF1E1035) : const Color(0xFFD6D8F8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.center,
                    child: SofIcon(
                      currentTrack['svg'] as String,
                      size: 72,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Title & Artist + Favorite Heart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTrack['title']!,
                        style: typography.headline.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.contentPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentTrack['artist']!,
                        style: typography.body.copyWith(
                          color: colors.contentSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SofIconButton(
                  variant: _isLiked ? SofButtonVariant.subtle : SofButtonVariant.ghost,
                  icon: SofIcon(
                    _isLiked ? SofIcons.heartFilled : SofIcons.heart,
                    size: 22,
                    color: _isLiked ? colors.danger : colors.contentSecondary,
                  ),
                  onPressed: () => setState(() => _isLiked = !_isLiked),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Luminous Slider (Scrubbing)
          SofSlider(
            value: _playbackPosition,
            luminous: true,
            trackHeight: 7.0,
            onChanged: (val) => setState(() => _playbackPosition = val),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(_playbackPosition),
                  style: typography.caption.copyWith(color: colors.contentSecondary),
                ),
                Text(
                  currentTrack['duration']!,
                  style: typography.caption.copyWith(color: colors.contentSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Playback Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SofIconButton(
                variant: _isShuffle ? SofButtonVariant.subtle : SofButtonVariant.ghost,
                icon: SofIcon(
                  SofIcons.shuffle,
                  size: 18,
                  color: _isShuffle ? colors.accent : colors.contentSecondary,
                ),
                onPressed: () => setState(() => _isShuffle = !_isShuffle),
              ),
              SofIconButton(
                size: SofButtonSize.large,
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.skipBack, size: 20),
                onPressed: () {
                  setState(() {
                    _activeTrackIndex = (_activeTrackIndex - 1 + _playlist.length) % _playlist.length;
                    _playbackPosition = 0.0;
                  });
                },
              ),
              // Main Play/Pause Button
              SofButton(
                size: SofButtonSize.large,
                variant: SofButtonVariant.filled,
                borderRadius: BorderRadius.circular(28),
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                child: SofIcon(
                  _isPlaying ? SofIcons.pause : SofIcons.play,
                  size: 20,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
              SofIconButton(
                size: SofButtonSize.large,
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.skipForward, size: 20),
                onPressed: () {
                  setState(() {
                    _activeTrackIndex = (_activeTrackIndex + 1) % _playlist.length;
                    _playbackPosition = 0.0;
                  });
                },
              ),
              SofIconButton(
                variant: SofButtonVariant.ghost,
                icon: const SofIcon(SofIcons.list, size: 20),
                onPressed: _showQueueSheet,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Featured Dynamic Playlist Tile
          SofAdaptiveTile(
            variant: SofSurfaceVariant.ambient,
            title: const Text('Soflume Spatial Audio'),
            subtitle: const Text('Dolby Atmos continuous soundscape enabled'),
            icon: const SofIcon(SofIcons.headphones, size: 20),
            statusBadge: const SofBadge(label: Text('Hi-Res Lossless'), variant: SofBadgeVariant.accent),
            onPressed: () {
              showSofToast(
                context: context,
                message: 'Spatial Audio is active',
                variant: SofBadgeVariant.accent,
              );
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
