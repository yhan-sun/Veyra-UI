import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

/// Full interactive Analytics Dashboard application showcasing
/// KPI tiles, luminous progress metrics, status alerts, filter chips, and data tables.
class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Transactions', 'Successful', 'Pending', 'Flagged'];

  final List<Map<String, dynamic>> _transactions = [
    {
      'customer': 'Alice Chen',
      'avatar': 'AC',
      'email': 'alice@soflume.dev',
      'amount': r'+$2,450.00',
      'status': 'Completed',
      'statusVariant': SofBadgeVariant.success,
      'date': 'Oct 13, 14:32',
    },
    {
      'customer': 'Markus Ray',
      'avatar': 'MR',
      'email': 'markus@linear.app',
      'amount': r'+$890.00',
      'status': 'Completed',
      'statusVariant': SofBadgeVariant.success,
      'date': 'Oct 13, 13:10',
    },
    {
      'customer': 'Elena Vane',
      'avatar': 'EV',
      'email': 'elena@raycast.com',
      'amount': r'+$4,120.00',
      'status': 'Pending',
      'statusVariant': SofBadgeVariant.warning,
      'date': 'Oct 13, 11:45',
    },
    {
      'customer': 'Devon Vance',
      'avatar': 'DV',
      'email': 'devon@vercel.com',
      'amount': r'+$1,650.00',
      'status': 'Completed',
      'statusVariant': SofBadgeVariant.success,
      'date': 'Oct 12, 18:22',
    },
  ];

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analytics Dashboard',
                      style: typography.display.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.contentPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Real-time overview of Soflume ecosystem metrics',
                      style: typography.body.copyWith(
                        color: colors.contentSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SofButton(
                variant: SofButtonVariant.subtle,
                leading: const Text('⬇'),
                onPressed: () {
                  showSofToast(
                    context: context,
                    message: 'Report exported to CSV',
                    variant: SofBadgeVariant.success,
                  );
                },
                child: const Text('Export Data'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // System Status Alert
          const SofAlert(
            variant: SofBadgeVariant.success,
            icon: Text('✓'),
            title: Text('All Systems Operational'),
            message: Text('Global Edge Nodes operating at 99.98% uptime with 14ms latency.'),
          ),
          const SizedBox(height: 24),

          // 4 Adaptive KPI Metric Tiles
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final tileWidth = isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: tileWidth,
                    child: const SofAdaptiveTile(
                      variant: SofSurfaceVariant.ambient,
                      icon: Text('💰', style: TextStyle(fontSize: 18)),
                      value: Text(r'$128.4K'),
                      title: Text('Total Revenue'),
                      subtitle: Text('+18.4% vs last mo.'),
                      statusBadge: SofBadge(label: Text('+18.4%'), variant: SofBadgeVariant.success),
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: const SofAdaptiveTile(
                      variant: SofSurfaceVariant.solid,
                      icon: Text('👥', style: TextStyle(fontSize: 18)),
                      value: Text('48,290'),
                      title: Text('Active Users'),
                      subtitle: Text('+12.1% new signups'),
                      statusBadge: SofBadge(label: Text('+12.1%'), variant: SofBadgeVariant.accent),
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: const SofAdaptiveTile(
                      variant: SofSurfaceVariant.solid,
                      icon: Text('⚡', style: TextStyle(fontSize: 18)),
                      value: Text('99.98%'),
                      title: Text('System Uptime'),
                      subtitle: Text('Zero incident reports'),
                      statusBadge: SofBadge(label: Text('Optimal'), variant: SofBadgeVariant.success),
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: const SofAdaptiveTile(
                      variant: SofSurfaceVariant.solid,
                      icon: Text('🎯', style: TextStyle(fontSize: 18)),
                      value: Text('4.62%'),
                      title: Text('Conversion Rate'),
                      subtitle: Text('+0.8% checkout flow'),
                      statusBadge: SofBadge(label: Text('+0.8%'), variant: SofBadgeVariant.warning),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // Resource Allocation & Live Performance
          Row(
            children: [
              Expanded(
                child: SofCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'GPU Frame Budget (120Hz Target)',
                              style: typography.title.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const SofBadge(label: Text('8.3ms Budget'), variant: SofBadgeVariant.accent),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Impeller raster time averages 4.2ms. Zero frame drops detected.',
                        style: typography.caption.copyWith(color: colors.contentSecondary),
                      ),
                      const SizedBox(height: 16),
                      const SofProgress(
                        value: 0.51,
                        luminous: true,
                        trackHeight: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Transactions Table Section
          Text(
            'RECENT TRANSACTIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.contentSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = index == _selectedFilterIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SofChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilterIndex = index),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Table Card
          SofCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: _transactions.map((tx) {
                return SofListTile(
                  leading: SofAvatar(
                    initials: tx['avatar'] as String,
                    size: 38,
                  ),
                  title: Text(tx['customer'] as String),
                  subtitle: Text('${tx['email']} • ${tx['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tx['amount'] as String,
                        style: typography.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.contentPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SofBadge(
                        label: Text(tx['status'] as String),
                        variant: tx['statusVariant'] as SofBadgeVariant,
                      ),
                    ],
                  ),
                  onPressed: () {
                    showSofToast(
                      context: context,
                      message: 'Viewing transaction for ${tx['customer']}',
                      variant: SofBadgeVariant.accent,
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
