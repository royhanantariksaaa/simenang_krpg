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

class DetailedProfileManagementCard extends StatefulWidget {
  final ProfileManagement profile;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;

  const DetailedProfileManagementCard({
    Key? key,
    required this.profile,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DetailedProfileManagementCard> createState() => _DetailedProfileManagementCardState();
}

class _DetailedProfileManagementCardState extends State<DetailedProfileManagementCard> {
  bool _isBasicInfoExpanded = true;
  bool _isContactInfoExpanded = true;
  bool _isClassroomInfoExpanded = false;
  bool _isMetadataExpanded = false;

  @override
  Widget build(BuildContext context) {
    return KRPGCard.training(
      isSelected: widget.isSelected,
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          KRPGSpacing.verticalMD,
          _buildBasicInfoSection(),
          KRPGSpacing.verticalSM,
          _buildContactInfoSection(),
          KRPGSpacing.verticalSM,
          _buildClassroomInfoSection(),
          KRPGSpacing.verticalSM,
          _buildMetadataSection(),
          KRPGSpacing.verticalMD,
          _buildActions(),
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
          child: Icon(
            KRPGIcons.person,
            color: KRPGTheme.primaryColor,
            size: 28,
          ),
        ),
        KRPGSpacing.horizontalMD,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.profile.name,
                style: KRPGTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXS,
              Text(
                'Profile ID: ${widget.profile.id}',
                style: KRPGTextStyles.bodyMediumSecondary,
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
    final isActive = widget.profile.isActive;
    final color = isActive ? KRPGTheme.successColor : KRPGTheme.dangerColor;
    final text = isActive ? 'Active' : 'Inactive';
    final icon = isActive ? Icons.check_circle_outline_rounded : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: KRPGTextStyles.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildCollapsibleSection(
      title: 'Basic Information',
      icon: KRPGIcons.info,
      isExpanded: _isBasicInfoExpanded,
      onToggle: () => setState(() => _isBasicInfoExpanded = !_isBasicInfoExpanded),
      children: [
        _buildInfoRow('Full Name', widget.profile.name),
        _buildInfoRow('Account ID', widget.profile.accountId),
        _buildInfoRow('Gender', widget.profile.genderDisplay),
        _buildInfoRow('Birth Date', _formatDate(widget.profile.birthDate)),
        _buildInfoRow('Age', '${widget.profile.age} years old'),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildCollapsibleSection(
      title: 'Contact Information',
      icon: KRPGIcons.phone,
      isExpanded: _isContactInfoExpanded,
      onToggle: () => setState(() => _isContactInfoExpanded = !_isContactInfoExpanded),
      children: [
        if (widget.profile.phone != null && widget.profile.phone!.isNotEmpty)
          _buildInfoRow('Phone', widget.profile.phone!)
        else
          _buildInfoRow('Phone', 'Not provided'),
        if (widget.profile.address != null && widget.profile.address!.isNotEmpty)
          _buildInfoRow('Address', widget.profile.address!)
        else
          _buildInfoRow('Address', 'Not provided'),
        if (widget.profile.profilePictureUrl != null && widget.profile.profilePictureUrl!.isNotEmpty)
          _buildInfoRow('Profile Picture', 'Available'),
        _buildInfoRow('Status', widget.profile.statusDisplay),
      ],
    );
  }

  Widget _buildClassroomInfoSection() {
    return _buildCollapsibleSection(
      title: 'Classroom Information',
      icon: KRPGIcons.group,
      isExpanded: _isClassroomInfoExpanded,
      onToggle: () => setState(() => _isClassroomInfoExpanded = !_isClassroomInfoExpanded),
      children: [
        if (widget.profile.classroomId != null)
          _buildInfoRow('Classroom ID', widget.profile.classroomId!)
        else
          _buildInfoRow('Classroom ID', 'Not assigned'),
      ],
    );
  }

  Widget _buildMetadataSection() {
    return _buildCollapsibleSection(
      title: 'Metadata',
      icon: KRPGIcons.settings,
      isExpanded: _isMetadataExpanded,
      onToggle: () => setState(() => _isMetadataExpanded = !_isMetadataExpanded),
      children: [
        _buildInfoRow('Profile ID', widget.profile.id),
        _buildInfoRow('Account ID', widget.profile.accountId),
        _buildInfoRow('Status', widget.profile.statusDisplay),
      ],
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: KRPGTheme.neutralLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: KRPGTheme.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: KRPGTextStyles.heading5,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: KRPGTheme.neutralMedium,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: children,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.neutralMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: KRPGTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final List<Widget> actions = [];

    if (widget.onEdit != null) {
      actions.add(
        KRPGButton.secondary(
          text: 'Edit',
          icon: KRPGIcons.edit,
          onPressed: widget.onEdit,
        ),
      );
    }

    if (widget.onDelete != null) {
      actions.add(
        KRPGButton.danger(
          text: 'Delete',
          icon: KRPGIcons.delete,
          onPressed: widget.onDelete,
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions.map((action) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: action,
      )).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(date);
  }
} 