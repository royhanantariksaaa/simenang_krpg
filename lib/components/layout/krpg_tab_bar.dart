import 'package:flutter/material.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';

class KRPGTabBar extends StatelessWidget {
  final List<KRPGTab> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final TabBarIndicatorSize indicatorSize;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final EdgeInsetsGeometry? labelPadding;

  const KRPGTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.isScrollable = false,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KRPGTheme.backgroundPrimary,
        border: Border(
          bottom: BorderSide(
            color: KRPGTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: tabs.map((tab) => _buildTab(tab)).toList(),
        onTap: onTap,
        isScrollable: isScrollable,
        indicatorSize: indicatorSize,
        indicatorColor: indicatorColor ?? KRPGTheme.primaryColor,
        labelColor: labelColor ?? KRPGTheme.primaryColor,
        unselectedLabelColor: unselectedLabelColor ?? KRPGTheme.textMedium,
        labelStyle: KRPGTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: KRPGTextStyles.bodyMedium,
        labelPadding: labelPadding ?? EdgeInsets.symmetric(
          horizontal: KRPGTheme.spacingMd,
          vertical: KRPGTheme.spacingSm,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 2,
            color: indicatorColor ?? KRPGTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(KRPGTab tab) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null) ...[
            Icon(
              tab.icon,
              size: 18,
            ),
            KRPGSpacing.horizontalXS,
          ],
          Flexible(
            child: Text(
              tab.label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (tab.badge != null) ...[
            KRPGSpacing.horizontalXS,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: tab.badgeColor ?? KRPGTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tab.badge!,
                style: KRPGTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class KRPGTab {
  final String label;
  final IconData? icon;
  final String? badge;
  final Color? badgeColor;

  const KRPGTab({
    required this.label,
    this.icon,
    this.badge,
    this.badgeColor,
  });
}

class KRPGSegmentedTabBar extends StatefulWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const KRPGSegmentedTabBar({
    Key? key,
    required this.options,
    required this.selectedIndex,
    this.onChanged,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  }) : super(key: key);

  @override
  State<KRPGSegmentedTabBar> createState() => _KRPGSegmentedTabBarState();
}

class _KRPGSegmentedTabBarState extends State<KRPGSegmentedTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.unselectedColor ?? KRPGTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
      ),
      child: Row(
        children: widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = index == widget.selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onChanged?.call(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: KRPGTheme.spacingSm,
                  horizontal: KRPGTheme.spacingMd,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (widget.selectedColor ?? KRPGTheme.backgroundPrimary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                  boxShadow: isSelected ? KRPGTheme.shadowSmall : null,
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: KRPGTextStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? (widget.selectedTextColor ?? KRPGTheme.primaryColor)
                        : (widget.unselectedTextColor ?? KRPGTheme.textMedium),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class KRPGFilterChipBar extends StatefulWidget {
  final List<String> options;
  final List<int> selectedIndices;
  final ValueChanged<List<int>>? onChanged;
  final bool multiSelect;
  final Color? selectedColor;
  final Color? unselectedColor;

  const KRPGFilterChipBar({
    Key? key,
    required this.options,
    required this.selectedIndices,
    this.onChanged,
    this.multiSelect = true,
    this.selectedColor,
    this.unselectedColor,
  }) : super(key: key);

  @override
  State<KRPGFilterChipBar> createState() => _KRPGFilterChipBarState();
}

class _KRPGFilterChipBarState extends State<KRPGFilterChipBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = widget.selectedIndices.contains(index);

          return Padding(
            padding: const EdgeInsets.only(right: KRPGTheme.spacingSm),
            child: FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                final newIndices = List<int>.from(widget.selectedIndices);
                
                if (widget.multiSelect) {
                  if (selected) {
                    newIndices.add(index);
                  } else {
                    newIndices.remove(index);
                  }
                } else {
                  newIndices.clear();
                  if (selected) {
                    newIndices.add(index);
                  }
                }
                
                widget.onChanged?.call(newIndices);
              },
              selectedColor: widget.selectedColor ?? KRPGTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: widget.selectedColor ?? KRPGTheme.primaryColor,
              labelStyle: KRPGTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? (widget.selectedColor ?? KRPGTheme.primaryColor)
                    : KRPGTheme.textMedium,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              backgroundColor: widget.unselectedColor ?? KRPGTheme.backgroundSecondary,
              side: BorderSide(
                color: isSelected
                    ? (widget.selectedColor ?? KRPGTheme.primaryColor)
                    : KRPGTheme.borderColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 