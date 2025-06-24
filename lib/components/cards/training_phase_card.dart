import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/training_phase_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:intl/intl.dart';

class TrainingPhaseCard extends StatelessWidget {
  final TrainingPhase phase;
  final VoidCallback? onTap;
  final VoidCallback? onViewTrainings;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const TrainingPhaseCard({
    Key? key,
    required this.phase,
    this.onTap,
    this.onViewTrainings,
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
          if (showActions && onViewTrainings != null) ...[
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
          KRPGIcons.training,
          color: KRPGTheme.primaryColor,
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phase.phaseName,
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXXS,
              Text(
                'Duration: ${phase.durationDisplay}',
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
    
    if (phase.isActive) {
      color = KRPGTheme.successColor;
      text = 'Active';
    } else if (phase.startDate != null && DateTime.now().isBefore(phase.startDate!)) {
      color = KRPGTheme.infoColor;
      text = 'Upcoming';
    } else {
      color = KRPGTheme.neutralMedium;
      text = 'Completed';
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
        if (phase.description != null && phase.description!.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  phase.description!,
                  style: KRPGTextStyles.bodyMediumSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          KRPGSpacing.verticalSM,
        ],
        Row(
          children: [
            _buildDetailItem(
              label: 'Duration',
              value: phase.durationDisplay,
              icon: KRPGIcons.time,
            ),
            KRPGSpacing.horizontalMD,
            if (phase.activeTrainings != null)
              _buildDetailItem(
                label: 'Active Trainings',
                value: '${phase.activeTrainings}',
                icon: KRPGIcons.training,
              ),
          ],
        ),
        if (phase.startDate != null && phase.endDate != null) ...[
          KRPGSpacing.verticalSM,
          Row(
            children: [
              _buildDetailItem(
                label: 'Start Date',
                value: _formatDate(phase.startDate!),
                icon: KRPGIcons.date,
              ),
              KRPGSpacing.horizontalMD,
              _buildDetailItem(
                label: 'End Date',
                value: _formatDate(phase.endDate!),
                icon: KRPGIcons.date,
              ),
            ],
          ),
          KRPGSpacing.verticalSM,
          _buildProgressSection(),
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

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              KRPGIcons.chart,
              size: 16,
              color: KRPGTheme.neutralMedium,
            ),
            KRPGSpacing.horizontalXS,
            Text(
              'Progress',
              style: KRPGTextStyles.caption,
            ),
          ],
        ),
        KRPGSpacing.verticalXXS,
        LinearProgressIndicator(
          value: phase.progressPercentage / 100,
          backgroundColor: KRPGTheme.neutralLight,
          valueColor: AlwaysStoppedAnimation<Color>(KRPGTheme.primaryColor),
        ),
        KRPGSpacing.verticalXXS,
        Text(
          '${phase.progressPercentage.toStringAsFixed(1)}% Complete',
          style: KRPGTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        KRPGButton.primary(
          text: 'View Trainings',
          icon: KRPGIcons.training,
          size: KRPGButtonSize.small,
          onPressed: onViewTrainings,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
} 