import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/competition_result_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:intl/intl.dart';

class CompetitionResultCard extends StatelessWidget {
  final CompetitionResult result;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const CompetitionResultCard({
    Key? key,
    required this.result,
    this.onTap,
    this.onEdit,
    this.showActions = true,
    this.isCompact = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KRPGCard.competition(
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
          KRPGIcons.medal,
          color: _getMedalColor(),
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.athleteName ?? 'Competition Result',
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXXS,
              Text(
                result.competitionName ?? 'Competition',
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

  Color _getMedalColor() {
    if (result.position == null) return KRPGTheme.neutralMedium;
    switch (result.position) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey[400]!; // Silver
      case 3:
        return Colors.brown[300]!; // Bronze
      default:
        return KRPGTheme.primaryColor;
    }
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    
    switch (result.resultStatus) {
      case CompetitionResultStatus.completed:
        color = KRPGTheme.successColor;
        text = 'Completed';
        break;
      case CompetitionResultStatus.dns:
        color = KRPGTheme.neutralMedium;
        text = 'DNS';
        break;
      case CompetitionResultStatus.dnf:
        color = KRPGTheme.warningColor;
        text = 'DNF';
        break;
      case CompetitionResultStatus.dq:
        color = KRPGTheme.dangerColor;
        text = 'DQ';
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
            if (result.position != null)
              _buildDetailItem(
                label: 'Position',
                value: '${result.position}${_getPositionSuffix(result.position!)}',
                icon: KRPGIcons.medal,
              ),
            KRPGSpacing.horizontalMD,
            if (result.timeResult != null)
              _buildDetailItem(
                label: 'Time',
                value: result.timeResult!,
                icon: KRPGIcons.stopwatch,
              ),
          ],
        ),
        KRPGSpacing.verticalSM,
        Row(
          children: [
            _buildDetailItem(
              label: 'Result Type',
              value: result.resultType.displayName,
              icon: KRPGIcons.competition,
            ),
            KRPGSpacing.horizontalMD,
            if (result.points != null)
              _buildDetailItem(
                label: 'Points',
                value: result.points!.toStringAsFixed(1),
                icon: KRPGIcons.star,
              ),
          ],
        ),
        if (result.category != null && result.category!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          Row(
            children: [
              _buildDetailItem(
                label: 'Category',
                value: result.category!,
                icon: KRPGIcons.group,
              ),
            ],
          ),
        ],
        if (result.notes != null && result.notes!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          _buildNotesSection(),
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

  Widget _buildNotesSection() {
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
          result.notes!,
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
          text: 'Edit Result',
          icon: KRPGIcons.edit,
          size: KRPGButtonSize.small,
          onPressed: onEdit,
        ),
      ],
    );
  }

  String _getPositionSuffix(int position) {
    if (position >= 11 && position <= 13) return 'th';
    switch (position % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
} 