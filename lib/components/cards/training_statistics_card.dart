import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/training_statistics_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:intl/intl.dart';

class TrainingStatisticsCard extends StatelessWidget {
  final TrainingStatistics statistics;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const TrainingStatisticsCard({
    Key? key,
    required this.statistics,
    this.onTap,
    this.onEdit,
    this.showActions = true,
    this.isCompact = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KRPGCard.training(
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
        Icon(
          KRPGIcons.chart,
          color: KRPGTheme.primaryColor,
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statistics.athleteName ?? 'Training Statistics',
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXXS,
              Text(
                'Stroke: ${statistics.stroke}',
                style: KRPGTextStyles.bodyMediumSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildEnergySystemBadge(),
      ],
    );
  }

  Widget _buildEnergySystemBadge() {
    Color color;
    String text;
    
    if (statistics.energySystem.contains('aerobic')) {
      color = KRPGTheme.successColor;
      text = 'Aerobic';
    } else if (statistics.energySystem.contains('anaerobic')) {
      color = KRPGTheme.warningColor;
      text = 'Anaerobic';
    } else if (statistics.energySystem.contains('vo2max')) {
      color = KRPGTheme.infoColor;
      text = 'VO2 Max';
    } else {
      color = KRPGTheme.neutralMedium;
      text = 'Unknown';
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
            if (statistics.duration != null)
              _buildDetailItem(
                label: 'Duration',
                value: statistics.duration!,
                icon: KRPGIcons.time,
              ),
            KRPGSpacing.horizontalMD,
            if (statistics.distance != null)
              _buildDetailItem(
                label: 'Distance',
                value: '${statistics.distance}m',
                icon: KRPGIcons.swimming,
              ),
          ],
        ),
        KRPGSpacing.verticalSM,
        Row(
          children: [
            _buildDetailItem(
              label: 'Energy System',
              value: statistics.energySystem.replaceAll('_', ' ').toUpperCase(),
              icon: KRPGIcons.favorite,
            ),
            KRPGSpacing.horizontalMD,
            if (statistics.trainingDate != null)
              _buildDetailItem(
                label: 'Date',
                value: _formatDate(statistics.trainingDate!),
                icon: KRPGIcons.date,
              ),
          ],
        ),
        if (statistics.note != null && statistics.note!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          _buildNoteSection(),
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

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              KRPGIcons.comment,
              size: 16,
              color: KRPGTheme.neutralMedium,
            ),
            KRPGSpacing.horizontalXS,
            Text(
              'Notes',
              style: KRPGTextStyles.caption,
            ),
          ],
        ),
        KRPGSpacing.verticalXXS,
        Text(
          statistics.note!,
          style: KRPGTextStyles.bodyMediumSecondary,
          maxLines: 3,
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
          text: 'Edit',
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