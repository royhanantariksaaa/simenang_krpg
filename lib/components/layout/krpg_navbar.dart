import 'package:flutter/material.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';

class KRPGNavbar extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final String? userAvatar;
  final String? userName;
  final String? userRole;

  const KRPGNavbar({
    Key? key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showSearch = false,
    this.searchHint,
    this.onSearchChanged,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.userAvatar,
    this.userName,
    this.userRole,
  }) : super(key: key);

  @override
  State<KRPGNavbar> createState() => _KRPGNavbarState();
}

class _KRPGNavbarState extends State<KRPGNavbar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: KRPGTheme.backgroundPrimary,
        boxShadow: KRPGTheme.shadowSmall,
        border: Border(
          bottom: BorderSide(
            color: KRPGTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: KRPGTheme.spacingMd),
          child: Row(
            children: [
              _buildLeading(),
              KRPGSpacing.horizontalMD,
              _buildTitle(),
              const Spacer(),
              _buildSearchBar(),
              KRPGSpacing.horizontalSM,
              _buildActions(),
              KRPGSpacing.horizontalSM,
              _buildUserMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (widget.leading != null) {
      return widget.leading!;
    }

    if (widget.onMenuPressed != null) {
      return IconButton(
        onPressed: widget.onMenuPressed,
        icon: Icon(
          KRPGIcons.menu,
          color: KRPGTheme.primaryColor,
          size: 24,
        ),
        tooltip: 'Menu',
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTitle() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: KRPGTextStyles.heading4.copyWith(
              color: KRPGTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.subtitle != null) ...[
            KRPGSpacing.verticalXS,
            Text(
              widget.subtitle!,
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.textMedium,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    if (!widget.showSearch) return const SizedBox.shrink();

    if (_isSearchExpanded) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 300,
        child: TextField(
          controller: _searchController,
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: widget.searchHint ?? 'Search...',
            hintStyle: KRPGTextStyles.bodyMedium.copyWith(
              color: KRPGTheme.textMedium,
            ),
            prefixIcon: Icon(
              KRPGIcons.search,
              color: KRPGTheme.textMedium,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isSearchExpanded = false;
                  _searchController.clear();
                  widget.onSearchChanged?.call('');
                });
              },
              icon: Icon(
                Icons.close,
                color: KRPGTheme.textMedium,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: KRPGTheme.backgroundSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: KRPGTheme.spacingSm,
              vertical: KRPGTheme.spacingXs,
            ),
          ),
          style: KRPGTextStyles.bodyMedium,
        ),
      );
    }

    return IconButton(
      onPressed: () {
        setState(() {
          _isSearchExpanded = true;
        });
      },
      icon: Icon(
        KRPGIcons.search,
        color: KRPGTheme.textMedium,
        size: 24,
      ),
      tooltip: 'Search',
    );
  }

  Widget _buildActions() {
    if (widget.actions != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions!,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            widget.onProfilePressed?.call();
            break;
          case 'settings':
            // Handle settings
            break;
          case 'logout':
            // Handle logout
            break;
        }
      },
      itemBuilder: (context) => [
        if (widget.userName != null)
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
                  child: widget.userAvatar != null
                      ? ClipOval(
                          child: Image.network(
                            widget.userAvatar!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                KRPGIcons.person,
                                color: KRPGTheme.primaryColor,
                                size: 16,
                              );
                            },
                          ),
                        )
                      : Icon(
                          KRPGIcons.person,
                          color: KRPGTheme.primaryColor,
                          size: 16,
                        ),
                ),
                KRPGSpacing.horizontalSM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.userName!,
                        style: KRPGTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.userRole != null)
                        Text(
                          widget.userRole!,
                          style: KRPGTextStyles.bodySmall.copyWith(
                            color: KRPGTheme.textMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(
                KRPGIcons.settings,
                size: 18,
                color: KRPGTheme.textMedium,
              ),
              KRPGSpacing.horizontalSM,
              const Text('Settings'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 18,
                color: KRPGTheme.dangerColor,
              ),
              KRPGSpacing.horizontalSM,
              Text(
                'Logout',
                style: KRPGTextStyles.bodyMedium.copyWith(
                  color: KRPGTheme.dangerColor,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: KRPGTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
              child: widget.userAvatar != null
                  ? ClipOval(
                      child: Image.network(
                        widget.userAvatar!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            KRPGIcons.person,
                            color: KRPGTheme.primaryColor,
                            size: 16,
                          );
                        },
                      ),
                    )
                  : Icon(
                      KRPGIcons.person,
                      color: KRPGTheme.primaryColor,
                      size: 16,
                    ),
            ),
            if (widget.userName != null) ...[
              KRPGSpacing.horizontalSM,
              Text(
                widget.userName!,
                style: KRPGTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              KRPGSpacing.horizontalXS,
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: KRPGTheme.textMedium,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 