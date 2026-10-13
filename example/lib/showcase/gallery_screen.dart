import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// Comprehensive interactive gallery demonstrating all Soflume UI components.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Interactive state variables
  bool _toggleVal1 = true;
  bool _toggleVal2 = true;
  bool? _checkboxVal1 = true;
  bool? _checkboxVal2 = false;
  int _radioVal = 1;
  int _segmentedVal = 0;
  double _sliderVal = 0.65;
  SofMorphingState _morphState = SofMorphingState.idle;
  bool _buttonLoading = false;
  final TextEditingController _inputController = TextEditingController(text: 'Soft Lumen Design');

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _cycleMorphState() {
    setState(() {
      switch (_morphState) {
        case SofMorphingState.idle:
          _morphState = SofMorphingState.loading;
          break;
        case SofMorphingState.loading:
          _morphState = SofMorphingState.success;
          break;
        case SofMorphingState.success:
          _morphState = SofMorphingState.error;
          break;
        case SofMorphingState.error:
          _morphState = SofMorphingState.idle;
          break;
      }
    });
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
          Text(
            'Component Gallery',
            style: typography.display.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Explore Soflume UI interactive primitives, controls, and signature components.',
            style: typography.body.copyWith(color: colors.contentSecondary),
          ),
          const SizedBox(height: 32),

          // 1. BRAND SIGNATURES
          _buildCategoryHeader('BRAND SIGNATURE COMPONENTS'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // Live Capsule
              SofCard(
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SofLiveCapsule', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Floating status capsule with expandable micro-interaction.', style: typography.caption),
                    const SizedBox(height: 16),
                    SofLiveCapsule(
                      leading: const Text('⚡'),
                      title: const Text('Exporting 4K Video...'),
                      trailing: const SofBadge(label: Text('78%'), variant: SofBadgeVariant.accent),
                      expandedChild: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated time: 14s', style: TextStyle(fontSize: 12)),
                          SofButton(
                            size: SofButtonSize.small,
                            variant: SofButtonVariant.subtle,
                            onPressed: () {},
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Morphing Button
              SofCard(
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SofMorphingButton', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Button → Spinner Pill → Checkmark state morph.', style: typography.caption),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SofMorphingButton(
                          state: _morphState,
                          onPressed: _cycleMorphState,
                          child: const Text('Tap to Morph'),
                        ),
                        const SizedBox(width: 14),
                        SofButton(
                          size: SofButtonSize.small,
                          variant: SofButtonVariant.ghost,
                          onPressed: () => setState(() => _morphState = SofMorphingState.idle),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Adaptive Tile
              SizedBox(
                width: 340,
                child: SofAdaptiveTile(
                  variant: SofSurfaceVariant.ambient,
                  icon: const Text('🎧', style: TextStyle(fontSize: 18)),
                  value: const Text('Spatial Audio'),
                  title: const Text('Dolby Atmos Active'),
                  subtitle: const Text('Dynamic head tracking connected'),
                  statusBadge: const SofBadge(label: Text('Lossless'), variant: SofBadgeVariant.accent),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // 2. BUTTONS & MICRO-INTERACTIONS
          _buildCategoryHeader('BUTTONS & MICRO-INTERACTIONS'),
          SofCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Variants & Sizes', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SofButton(
                      variant: SofButtonVariant.filled,
                      onPressed: () {},
                      child: const Text('Filled Action'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.subtle,
                      onPressed: () {},
                      child: const Text('Subtle Tint'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.outlined,
                      onPressed: () {},
                      child: const Text('Outlined'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.ghost,
                      onPressed: () {},
                      child: const Text('Ghost'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.danger,
                      onPressed: () {},
                      child: const Text('Danger'),
                    ),
                    SofButton(
                      variant: SofButtonVariant.filled,
                      loading: _buttonLoading,
                      onPressed: () {
                        setState(() => _buttonLoading = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) setState(() => _buttonLoading = false);
                        });
                      },
                      child: const Text('Click to Load'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Icon Buttons & Shapes', style: typography.label.copyWith(color: colors.contentSecondary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SofIconButton(
                      icon: const Text('★'),
                      variant: SofButtonVariant.filled,
                      onPressed: () {},
                    ),
                    SofIconButton(
                      icon: const Text('♥'),
                      variant: SofButtonVariant.subtle,
                      onPressed: () {},
                    ),
                    SofIconButton(
                      icon: const Text('⚡'),
                      shape: SofIconButtonShape.circle,
                      variant: SofButtonVariant.outlined,
                      onPressed: () {},
                    ),
                    SofIconButton(
                      icon: const Text('⚙'),
                      variant: SofButtonVariant.ghost,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // 3. SELECTION & INPUT CONTROLS
          _buildCategoryHeader('SELECTION & INPUT CONTROLS'),
          SofCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SofToggle (Standard)', style: typography.label),
                          const SizedBox(height: 8),
                          SofToggle(
                            value: _toggleVal1,
                            onChanged: (val) => setState(() => _toggleVal1 = val),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SofToggle (Luminous Glow)', style: typography.label),
                          const SizedBox(height: 8),
                          SofToggle(
                            value: _toggleVal2,
                            luminous: true,
                            onChanged: (val) => setState(() => _toggleVal2 = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Checkbox & Radio
                Row(
                  children: [
                    SofCheckbox(
                      value: _checkboxVal1,
                      label: const Text('Agreed to terms'),
                      onChanged: (val) => setState(() => _checkboxVal1 = val),
                    ),
                    const SizedBox(width: 24),
                    SofCheckbox(
                      value: _checkboxVal2,
                      label: const Text('Newsletter'),
                      onChanged: (val) => setState(() => _checkboxVal2 = val),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SofRadio<int>(
                      value: 1,
                      groupValue: _radioVal,
                      label: const Text('Option 1'),
                      onChanged: (v) => setState(() => _radioVal = v!),
                    ),
                    const SizedBox(width: 24),
                    SofRadio<int>(
                      value: 2,
                      groupValue: _radioVal,
                      label: const Text('Option 2'),
                      onChanged: (v) => setState(() => _radioVal = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Segmented Control
                Text('Segmented Control', style: typography.label),
                const SizedBox(height: 8),
                SofSegmentedControl<int>(
                  value: _segmentedVal,
                  onChanged: (v) => setState(() => _segmentedVal = v),
                  segments: const [
                    SofSegment(value: 0, label: Text('Day')),
                    SofSegment(value: 1, label: Text('Week')),
                    SofSegment(value: 2, label: Text('Month')),
                    SofSegment(value: 3, label: Text('Year')),
                  ],
                ),
                const SizedBox(height: 24),

                // Luminous Slider
                Text('Luminous Slider', style: typography.label),
                const SizedBox(height: 8),
                SofSlider(
                  value: _sliderVal,
                  luminous: true,
                  onChanged: (val) => setState(() => _sliderVal = val),
                ),
                const SizedBox(height: 24),

                // Text Input Field
                Text('Text Input', style: typography.label),
                const SizedBox(height: 8),
                SofTextField(
                  controller: _inputController,
                  placeholder: 'Enter component name...',
                  prefix: const Text('✎'),
                  suffix: const Text('✓'),
                  helperText: 'Continuous squircle focus outline with zero jitter',
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // 4. SOFT LUMEN MATERIALS
          _buildCategoryHeader('SOFT LUMEN MATERIAL SURFACES'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SofCard(
                variant: SofSurfaceVariant.solid,
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Solid Surface', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('High contrast, zero GPU blur overhead. Default for text cards.', style: typography.caption),
                  ],
                ),
              ),
              SofCard(
                variant: SofSurfaceVariant.frost,
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Frost Surface', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Translucent acrylic backdrop with 18σ Gaussian blur.', style: typography.caption),
                  ],
                ),
              ),
              SofCard(
                variant: SofSurfaceVariant.ambient,
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ambient Surface', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Directional soft lumen glow depth for hero spotlight cards.', style: typography.caption),
                  ],
                ),
              ),
              SofCard(
                variant: SofSurfaceVariant.floating,
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Floating Surface', style: typography.title.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Multi-stage soft diffusion shadows for modals & popovers.', style: typography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // 5. OVERLAYS & FEEDBACK
          _buildCategoryHeader('OVERLAYS & FEEDBACK'),
          SofCard(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SofButton(
                  variant: SofButtonVariant.subtle,
                  onPressed: () {
                    showSofDialog(
                      context: context,
                      builder: (context) {
                        return SofDialog(
                          title: const Text('Soflume Dialog'),
                          actions: [
                            SofButton(
                              variant: SofButtonVariant.filled,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Understand'),
                            ),
                          ],
                          child: const Text('A high-fidelity modal dialog with continuous curvature and spring scale transitions.'),
                        );
                      },
                    );
                  },
                  child: const Text('Open Modal Dialog'),
                ),
                SofButton(
                  variant: SofButtonVariant.subtle,
                  onPressed: () {
                    showSofSheet(
                      context: context,
                      builder: (context) {
                        return SofSheet(
                          title: const Text('Soflume Bottom Sheet'),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Smooth spring drag dismiss and rounded squircle top borders.'),
                              const SizedBox(height: 20),
                              SofButton(
                                variant: SofButtonVariant.filled,
                                fullWidth: true,
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close Sheet'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Open Bottom Sheet'),
                ),
                SofButton(
                  variant: SofButtonVariant.subtle,
                  onPressed: () {
                    showSofToast(
                      context: context,
                      message: 'Changes saved successfully',
                      icon: const Text('✓'),
                      variant: SofBadgeVariant.success,
                    );
                  },
                  child: const Text('Trigger Floating Toast'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: SoflumeTheme.colorsOf(context).accent,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
