import 'package:flutter/material.dart';
import '../../models/athlete_model.dart';
import '../ui/krpg_badge.dart';
import '../buttons/krpg_button.dart';
import 'krpg_card.dart';
import '../../design_system/krpg_design_system.dart';

class AthleteCard extends StatelessWidget {
  final Athlete athlete;
  final VoidCallback? onTap;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const AthleteCard({
    super.key,
    required this.athlete,
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
          backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            KRPGIcons.athlete,
            color: KRPGTheme.primaryColor,
            size: 24,
          ),
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                athlete.name,
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (athlete.email != null) ...[
                KRPGSpacing.verticalXXS,
                Text(
                  athlete.email!,
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
            if (athlete.level != null) ...[
              KRPGSpacing.verticalXXS,
              _buildLevelBadge(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    
    switch (athlete.status) {
      case AthleteStatus.active:
        color = KRPGTheme.successColor;
        text = 'Active';
        break;
      case AthleteStatus.inactive:
        color = KRPGTheme.neutralMedium;
        text = 'Inactive';
        break;
      case AthleteStatus.suspended:
        color = KRPGTheme.warningColor;
        text = 'Suspended';
        break;
      case AthleteStatus.retired:
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

  Widget _buildLevelBadge() {
    Color color;
    
    switch (athlete.level!) {
      case AthleteLevel.beginner:
        color = KRPGTheme.successColor;
        break;
      case AthleteLevel.intermediate:
        color = KRPGTheme.infoColor;
        break;
      case AthleteLevel.advanced:
        color = KRPGTheme.warningColor;
        break;
      case AthleteLevel.professional:
        color = KRPGTheme.dangerColor;
        break;
    }

    return KRPGBadge(
      text: athlete.level!.displayName,
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
            if (athlete.birthDate != null)
              _buildDetailItem(
                label: 'Age',
                value: '${athlete.age} years',
                icon: KRPGIcons.person,
              ),
            KRPGSpacing.horizontalMD,
            if (athlete.phone != null)
              _buildDetailItem(
                label: 'Phone',
                value: athlete.phone!,
                icon: KRPGIcons.phone,
              ),
          ],
        ),
        if (athlete.specializations != null && athlete.specializations!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          Wrap(
            spacing: KRPGTheme.spacingXs,
            runSpacing: KRPGTheme.spacingXs,
            children: athlete.specializations!.map((spec) => KRPGBadge(
              text: spec.name,
              backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
              textColor: KRPGTheme.primaryColor,
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