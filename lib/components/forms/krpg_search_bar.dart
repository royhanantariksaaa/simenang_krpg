import 'package:flutter/material.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';

class KRPGSearchBar extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final bool showFilter;
  final VoidCallback? onFilterPressed;
  final List<String>? filterOptions;
  final String? selectedFilter;
  final ValueChanged<String>? onFilterChanged;
  final bool autofocus;
  final bool enabled;

  const KRPGSearchBar({
    Key? key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.showFilter = false,
    this.onFilterPressed,
    this.filterOptions,
    this.selectedFilter,
    this.onFilterChanged,
    this.autofocus = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<KRPGSearchBar> createState() => _KRPGSearchBarState();
}

class _KRPGSearchBarState extends State<KRPGSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _hasText = widget.initialValue?.isNotEmpty ?? false;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KRPGTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
        border: Border.all(
          color: KRPGTheme.borderColor,
          width: 1,
        ),
        boxShadow: KRPGTheme.shadowSmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSubmitted?.call(),
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search...',
                hintStyle: KRPGTextStyles.bodyMedium.copyWith(
                  color: KRPGTheme.textMedium,
                ),
                prefixIcon: Icon(
                  KRPGIcons.search,
                  color: KRPGTheme.textMedium,
                  size: 20,
                ),
                suffixIcon: _hasText
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          widget.onClear?.call();
                          widget.onChanged?.call('');
                        },
                        icon: Icon(
                          Icons.clear,
                          color: KRPGTheme.textMedium,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: KRPGTheme.spacingMd,
                  vertical: KRPGTheme.spacingSm,
                ),
              ),
              style: KRPGTextStyles.bodyMedium,
            ),
          ),
          if (widget.showFilter) ...[
            Container(
              height: 32,
              width: 1,
              color: KRPGTheme.borderColor,
            ),
            _buildFilterButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    if (widget.filterOptions != null && widget.filterOptions!.isNotEmpty) {
      return PopupMenuButton<String>(
        onSelected: widget.onFilterChanged,
        itemBuilder: (context) => widget.filterOptions!.map((option) {
          return PopupMenuItem(
            value: option,
            child: Row(
              children: [
                if (widget.selectedFilter == option)
                  Icon(
                    Icons.check,
                    size: 18,
                    color: KRPGTheme.primaryColor,
                  )
                else
                  const SizedBox(width: 18),
                KRPGSpacing.horizontalSM,
                Text(option),
              ],
            ),
          );
        }).toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: KRPGTheme.spacingMd,
            vertical: KRPGTheme.spacingSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                KRPGIcons.filter,
                color: widget.selectedFilter != null
                    ? KRPGTheme.primaryColor
                    : KRPGTheme.textMedium,
                size: 20,
              ),
              if (widget.selectedFilter != null) ...[
                KRPGSpacing.horizontalXS,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: KRPGTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '1',
                    style: KRPGTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return IconButton(
      onPressed: widget.onFilterPressed,
      icon: Icon(
        KRPGIcons.filter,
        color: KRPGTheme.textMedium,
        size: 20,
      ),
    );
  }
}

class KRPGAdvancedSearchBar extends StatefulWidget {
  final String? hintText;
  final List<SearchFilter> filters;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<List<SearchFilter>>? onFiltersChanged;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;

  const KRPGAdvancedSearchBar({
    Key? key,
    this.hintText,
    required this.filters,
    this.onSearchChanged,
    this.onFiltersChanged,
    this.onSearch,
    this.onClear,
  }) : super(key: key);

  @override
  State<KRPGAdvancedSearchBar> createState() => _KRPGAdvancedSearchBarState();
}

class _KRPGAdvancedSearchBarState extends State<KRPGAdvancedSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KRPGSearchBar(
          hintText: widget.hintText,
          onChanged: widget.onSearchChanged,
          onSubmitted: () => widget.onSearch?.call(),
          showFilter: true,
          onFilterPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
        ),
        if (_showFilters) ...[
          KRPGSpacing.verticalSM,
          _buildFiltersPanel(),
        ],
      ],
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      decoration: BoxDecoration(
        color: KRPGTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
        border: Border.all(
          color: KRPGTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: KRPGTextStyles.heading5,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Reset all filters
                  final resetFilters = widget.filters.map((filter) {
                    return filter.copyWith(value: null);
                  }).toList();
                  widget.onFiltersChanged?.call(resetFilters);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          KRPGSpacing.verticalSM,
          ...widget.filters.map((filter) => _buildFilterItem(filter)),
          KRPGSpacing.verticalSM,
          Row(
            children: [
              const Spacer(),
              KRPGButton.secondary(
                text: 'Apply Filters',
                onPressed: () {
                  setState(() {
                    _showFilters = false;
                  });
                  widget.onSearch?.call();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(SearchFilter filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              filter.label,
              style: KRPGTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          KRPGSpacing.horizontalMD,
          Expanded(
            child: _buildFilterInput(filter),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInput(SearchFilter filter) {
    switch (filter.type) {
      case FilterType.text:
        return TextField(
          decoration: InputDecoration(
            hintText: filter.hint ?? 'Enter ${filter.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: KRPGTheme.spacingSm,
              vertical: KRPGTheme.spacingXs,
            ),
          ),
          onChanged: (value) {
            final updatedFilter = filter.copyWith(value: value);
            _updateFilter(updatedFilter);
          },
        );
      case FilterType.select:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: KRPGTheme.spacingSm,
              vertical: KRPGTheme.spacingXs,
            ),
          ),
          hint: Text(filter.hint ?? 'Select ${filter.label.toLowerCase()}'),
          items: filter.options?.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            final updatedFilter = filter.copyWith(value: value);
            _updateFilter(updatedFilter);
          },
        );
      case FilterType.date:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              final updatedFilter = filter.copyWith(
                value: date.toIso8601String(),
              );
              _updateFilter(updatedFilter);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: KRPGTheme.spacingSm,
              vertical: KRPGTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: KRPGTheme.borderColor),
              borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: KRPGTheme.textMedium,
                ),
                KRPGSpacing.horizontalSM,
                Text(
                  filter.value != null
                      ? DateTime.parse(filter.value!).toString().split(' ')[0]
                      : filter.hint ?? 'Select date',
                  style: KRPGTextStyles.bodyMedium.copyWith(
                    color: filter.value != null
                        ? KRPGTheme.textDark
                        : KRPGTheme.textMedium,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  void _updateFilter(SearchFilter updatedFilter) {
    final updatedFilters = widget.filters.map((filter) {
      return filter.key == updatedFilter.key ? updatedFilter : filter;
    }).toList();
    widget.onFiltersChanged?.call(updatedFilters);
  }
}

class SearchFilter {
  final String key;
  final String label;
  final FilterType type;
  final String? hint;
  final List<String>? options;
  final String? value;

  const SearchFilter({
    required this.key,
    required this.label,
    required this.type,
    this.hint,
    this.options,
    this.value,
  });

  SearchFilter copyWith({
    String? key,
    String? label,
    FilterType? type,
    String? hint,
    List<String>? options,
    String? value,
  }) {
    return SearchFilter(
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      hint: hint ?? this.hint,
      options: options ?? this.options,
      value: value ?? this.value,
    );
  }
}

enum FilterType {
  text,
  select,
  date,
} 