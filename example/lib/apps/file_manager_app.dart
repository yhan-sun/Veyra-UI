import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// Full Desktop-Adaptive File Manager application showcasing
/// responsive sidebar, breadcrumbs, search, grid/list view switcher, and file actions.
class FileManagerApp extends StatefulWidget {
  const FileManagerApp({super.key});

  @override
  State<FileManagerApp> createState() => _FileManagerAppState();
}

class _FileManagerAppState extends State<FileManagerApp> {
  int _selectedSidebarCategory = 0;
  int _viewMode = 0; // 0: Grid, 1: List
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _files = [
    {
      'name': 'Design-Tokens-v1.json',
      'type': 'json',
      'svg': SofIcons.fileText,
      'color': const Color(0xFF5362E8),
      'size': '24 KB',
      'updated': 'Today 14:20',
      'badge': 'Tokens',
    },
    {
      'name': 'Soflume-Architecture.pdf',
      'type': 'pdf',
      'svg': SofIcons.file,
      'color': const Color(0xFFF04438),
      'size': '4.2 MB',
      'updated': 'Yesterday',
      'badge': 'Doc',
    },
    {
      'name': 'Brand-Identity-Assets.zip',
      'type': 'archive',
      'svg': SofIcons.archive,
      'color': const Color(0xFFF79009),
      'size': '18.6 MB',
      'updated': 'Oct 10',
      'badge': null,
    },
    {
      'name': 'origin_squircle_shader.frag',
      'type': 'code',
      'svg': SofIcons.code,
      'color': const Color(0xFF12B76A),
      'size': '3.1 KB',
      'updated': 'Oct 09',
      'badge': 'Shader',
    },
    {
      'name': 'Gallery-Keynote-Presentation.key',
      'type': 'presentation',
      'svg': SofIcons.barChart,
      'color': const Color(0xFF9EA8FF),
      'size': '12.8 MB',
      'updated': 'Oct 08',
      'badge': null,
    },
    {
      'name': 'Music-Cover-Lumen-Art.png',
      'type': 'image',
      'svg': SofIcons.image,
      'color': const Color(0xFF8B5CF6),
      'size': '2.4 MB',
      'updated': 'Oct 05',
      'badge': 'Artwork',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFileDetails(Map<String, dynamic> file) {
    showSofDialog(
      context: context,
      builder: (context) {
        return SofDialog(
          title: Text(file['name'] as String),
          actions: [
            SofButton(
              variant: SofButtonVariant.ghost,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            SofButton(
              variant: SofButtonVariant.filled,
              onPressed: () {
                Navigator.of(context).pop();
                showSofToast(
                  context: context,
                  message: 'Downloading ${file['name']}...',
                  variant: SofBadgeVariant.success,
                );
              },
              child: const Text('Download'),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('File Type: ${file['type']}'),
              const SizedBox(height: 4),
              Text('Size: ${file['size']}'),
              const SizedBox(height: 4),
              Text('Modified: ${file['updated']}'),
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

    final filteredFiles = _files.where((f) {
      if (_searchQuery.isEmpty) return true;
      return (f['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SofAdaptiveBuilder(
      builder: (context, screenClass) {
        final isDesktop = screenClass == SofScreenClass.expanded;

        Widget contentArea = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.outlineSubtle, width: 0.8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SofBreadcrumb(
                      items: [
                        SofBreadcrumbItem(label: 'iCloud Drive', onTap: () {}),
                        SofBreadcrumbItem(label: 'Projects', onTap: () {}),
                        const SofBreadcrumbItem(label: 'Soflume-UI'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // View Switcher (Grid vs List)
                  SizedBox(
                    width: 160,
                    child: SofSegmentedControl<int>(
                      value: _viewMode,
                      onChanged: (mode) => setState(() => _viewMode = mode),
                      height: 34,
                      segments: const [
                        SofSegment(value: 0, label: Text('Grid')),
                        SofSegment(value: 1, label: Text('List')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SofButton(
                    size: SofButtonSize.small,
                    variant: SofButtonVariant.filled,
                    leading: const Text('+'),
                    onPressed: () {
                      showSofToast(
                        context: context,
                        message: 'New Folder created',
                        variant: SofBadgeVariant.accent,
                      );
                    },
                    child: const Text('New Folder'),
                  ),
                ],
              ),
            ),

            // Search Bar & Filter Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: SofTextField(
                      controller: _searchController,
                      placeholder: 'Search files and documents...',
                      prefix: const SofIcon(SofIcons.search, size: 16),
                      onChanged: (q) => setState(() => _searchQuery = q),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${filteredFiles.length} items',
                    style: typography.caption.copyWith(color: colors.contentSecondary),
                  ),
                ],
              ),
            ),

            // Files Listing Area
            Expanded(
              child: filteredFiles.isEmpty
                  ? SofEmptyState(
                      icon: SofIcon(SofIcons.folder, size: 40, color: colors.contentSecondary),
                      title: const Text('No Files Found'),
                      message: const Text('Try adjusting your search query or select another folder.'),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: _viewMode == 0
                          ? _buildGridView(filteredFiles)
                          : _buildListView(filteredFiles),
                    ),
            ),
          ],
        );

        if (!isDesktop) {
          // Compact / Tablet mode
          return contentArea;
        }

        // Expanded Desktop mode with Left Sidebar
        return Row(
          children: [
            // Left Navigation Sidebar
            Container(
              width: 240,
              decoration: BoxDecoration(
                color: colors.isDark ? colors.surfaceMuted : colors.surfaceMuted,
                border: Border(right: BorderSide(color: colors.outlineSubtle, width: 0.8)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 16),
                    child: Text(
                      'FAVORITES',
                      style: typography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.contentSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  _buildSidebarItem(0, SofIcons.cloud, 'iCloud Drive', '12'),
                  _buildSidebarItem(1, SofIcons.download, 'Downloads', '5'),
                  _buildSidebarItem(2, SofIcons.star, 'Starred', '8'),
                  _buildSidebarItem(3, SofIcons.trash, 'Trash', '0'),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 16),
                    child: Text(
                      'STORAGE POOL',
                      style: typography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.contentSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('68 GB of 200 GB Used', style: typography.caption),
                        const SizedBox(height: 8),
                        const SofProgress(value: 0.34, trackHeight: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(child: contentArea),
          ],
        );
      },
    );
  }

  Widget _buildSidebarItem(int index, String svg, String label, String count) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final isSelected = index == _selectedSidebarCategory;

    return GestureDetector(
      onTap: () => setState(() => _selectedSidebarCategory = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentSubtle : const Color(0x00000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SofIcon(
                  svg,
                  size: 16,
                  color: isSelected ? colors.accent : colors.contentSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? colors.accent : colors.contentPrimary,
                  ),
                ),
              ],
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: 11,
                color: colors.contentSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> files) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: files.map((file) {
        final color = file['color'] as Color;
        return SizedBox(
          width: 170,
          child: SofCard(
            variant: SofSurfaceVariant.solid,
            padding: const EdgeInsets.all(14),
            onPressed: () => _showFileDetails(file),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SofIcon(file['svg'] as String, size: 24, color: color),
                    ),
                    if (file['badge'] != null)
                      SofBadge(label: Text(file['badge'] as String), variant: SofBadgeVariant.accent),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  file['name'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${file['size']} • ${file['updated']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: SoflumeTheme.colorsOf(context).contentSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> files) {
    return SofCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: files.map((file) {
          final color = file['color'] as Color;
          return SofListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SofIcon(file['svg'] as String, size: 18, color: color),
            ),
            title: Text(file['name'] as String),
            subtitle: Text('Modified ${file['updated']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(file['size'] as String),
                const SizedBox(width: 8),
                if (file['badge'] != null)
                  SofBadge(label: Text(file['badge'] as String), variant: SofBadgeVariant.accent),
              ],
            ),
            onPressed: () => _showFileDetails(file),
          );
        }).toList(),
      ),
    );
  }
}
