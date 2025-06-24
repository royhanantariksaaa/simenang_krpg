import 'package:flutter/material.dart';
import '../../models/coach_model.dart';
import '../ui/krpg_badge.dart';
import '../buttons/krpg_button.dart';
import 'krpg_card.dart';
import '../../design_system/krpg_design_system.dart';

class CoachCard extends StatelessWidget {
  final Coach coach;
  final VoidCallback? onTap;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const CoachCard({
    super.key,
    required this.coach,
    this.onTap,
    this.showActions = false,
    this.isCompact = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return KRPGCard.list(
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
          backgroundColor: KRPGTheme.secondaryColor.withOpacity(0.1),
          child: Icon(
            KRPGIcons.coach,
            color: KRPGTheme.secondaryColor,
            size: 24,
          ),
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coach.name,
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (coach.email != null) ...[
                KRPGSpacing.verticalXXS,
                Text(
                  coach.email!,
                  style: KRPGTextStyles.bodyMediumSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStatusBadge(),
            if (coach.experience != null) ...[
              KRPGSpacing.verticalXXS,
              _buildExperienceBadge(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    
    switch (coach.status) {
      case CoachStatus.active:
        color = KRPGTheme.successColor;
        text = 'Active';
        break;
      case CoachStatus.inactive:
        color = KRPGTheme.neutralMedium;
        text = 'Inactive';
        break;
      case CoachStatus.onLeave:
        color = KRPGTheme.warningColor;
        text = 'On Leave';
        break;
      case CoachStatus.retired:
        color = KRPGTheme.neutralLight;
        text = 'Retired';
        break;
    }

    return KRPGBadge(
      text: text,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      fontSize: KRPGTheme.fontSizeXs,
    );
  }

  Widget _buildExperienceBadge() {
    return KRPGBadge(
      text: coach.experience!,
      backgroundColor: KRPGTheme.secondaryColor.withOpacity(0.1),
      textColor: KRPGTheme.secondaryColor,
      fontSize: KRPGTheme.fontSizeXs,
    );
  }

  Widget _buildDetails() {
    return Column(
      children: [
        Row(
          children: [
            if (coach.phone != null)
              _buildDetailItem(
                label: 'Phone',
                value: coach.phone!,
                icon: KRPGIcons.phone,
              ),
            KRPGSpacing.horizontalMD,
            if (coach.specialization != null)
              _buildDetailItem(
                label: 'Specialization',
                value: coach.specialization!,
                icon: KRPGIcons.training,
              ),
          ],
        ),
        if (coach.certifications != null && coach.certifications!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          Wrap(
            spacing: KRPGTheme.spacingXs,
            runSpacing: KRPGTheme.spacingXs,
            children: coach.certifications!.take(3).map((cert) => KRPGBadge(
              text: cert,
              backgroundColor: KRPGTheme.accentColor.withOpacity(0.1),
              textColor: KRPGTheme.accentColor,
              fontSize: KRPGTheme.fontSizeXs,
            )).toList(),
          ),
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
} 