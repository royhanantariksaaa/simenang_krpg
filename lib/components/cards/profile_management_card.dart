import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/profile_management_model.dart';
import 'package:simenang_krpg/models/user_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:intl/intl.dart';

class ProfileManagementCard extends StatelessWidget {
  final ProfileManagement profile;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const ProfileManagementCard({
    Key? key,
    required this.profile,
    this.onTap,
    this.onEdit,
    this.showActions = true,
    this.isCompact = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KRPGCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (!isCompact) ...[
            KRPGSpacing.verticalSM,
            _buildDetails(),
          ],
          if (showActions && onEdit != null) ...[
            KRPGSpacing.verticalMD,
            _buildActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
          backgroundImage: profile.profilePictureUrl != null
              ? NetworkImage(profile.profilePictureUrl!)
              : null,
          child: profile.profilePictureUrl == null
              ? Icon(
                  KRPGIcons.person,
                  color: KRPGTheme.primaryColor,
                  size: 24,
                )
              : null,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXXS,
              Text(
                'Age: ${profile.age} years',
                style: KRPGTextStyles.bodyMediumSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    
    switch (profile.status) {
      case ProfileStatus.active:
        color = KRPGTheme.successColor;
        text = 'Active';
        break;
      case ProfileStatus.inactive:
        color = KRPGTheme.neutralMedium;
        text = 'Inactive';
        break;
      case ProfileStatus.pending:
        color = KRPGTheme.warningColor;
        text = 'Pending';
        break;
      case ProfileStatus.suspended:
        color = KRPGTheme.dangerColor;
        text = 'Suspended';
        break;
      case ProfileStatus.banned:
        color = KRPGTheme.dangerColor;
        text = 'Banned';
        break;
      case ProfileStatus.deleted:
        color = KRPGTheme.neutralMedium;
        text = 'Deleted';
        break;
    }

    return KRPGBadge(
      text: text,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      fontSize: KRPGTheme.fontSizeXs,
    );
  }

  Widget _buildDetails() {
    return Column(
      children: [
        Row(
          children: [
            _buildDetailItem(
              label: 'Gender',
              value: profile.genderDisplay,
              icon: KRPGIcons.person,
            ),
            KRPGSpacing.horizontalMD,
            _buildDetailItem(
              label: 'Birth Date',
              value: _formatDate(profile.birthDate),
              icon: KRPGIcons.date,
            ),
          ],
        ),
        KRPGSpacing.verticalSM,
        Row(
          children: [
            if (profile.phone != null)
              _buildDetailItem(
                label: 'Phone',
                value: profile.phone!,
                icon: KRPGIcons.phone,
              ),
            KRPGSpacing.horizontalMD,
            if (profile.classroomId != null)
              _buildDetailItem(
                label: 'Classroom',
                value: 'ID: ${profile.classroomId}',
                icon: KRPGIcons.group,
              ),
          ],
        ),
        if (profile.address != null && profile.address!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          _buildAddressSection(),
        ],
      ],
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: KRPGTheme.neutralMedium,
          ),
          KRPGSpacing.horizontalXS,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: KRPGTextStyles.caption,
                ),
                Text(
                  value,
                  style: KRPGTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              KRPGIcons.location,
              size: 16,
              color: KRPGTheme.neutralMedium,
            ),
            KRPGSpacing.horizontalXS,
            Text(
              'Address',
              style: KRPGTextStyles.caption,
            ),
          ],
        ),
        KRPGSpacing.verticalXXS,
        Text(
          profile.address!,
          style: KRPGTextStyles.bodyMediumSecondary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        KRPGButton.secondary(
          text: 'Edit Profile',
          icon: KRPGIcons.edit,
          size: KRPGButtonSize.small,
          onPressed: onEdit,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
} 