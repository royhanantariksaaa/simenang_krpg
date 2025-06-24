import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/training_model.dart';
import 'krpg_card.dart';
import '../ui/krpg_badge.dart';
import '../buttons/krpg_button.dart';
import '../../design_system/krpg_design_system.dart';

class TrainingCard extends StatelessWidget {
  final Training training;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onMarkAttendance;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const TrainingCard({
    super.key,
    required this.training,
    this.onTap,
    this.onJoin,
    this.onMarkAttendance,
    this.showActions = true,
    this.isCompact = false,
    this.isSelected = false,
  });

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
          if (showActions && (onJoin != null || onMarkAttendance != null)) ...[
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
                training.title,
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (training.description != null) ...[
                KRPGSpacing.verticalXXS,
                Text(
                  training.description!,
                  style: KRPGTextStyles.bodyMediumSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
    
    switch (training.status) {
      case TrainingStatus.active:
        color = KRPGTheme.successColor;
        text = 'Active';
        break;
      case TrainingStatus.inactive:
        color = KRPGTheme.neutralMedium;
        text = 'Inactive';
        break;
      case TrainingStatus.completed:
        color = KRPGTheme.neutralMedium;
        text = 'Completed';
        break;
      case TrainingStatus.cancelled:
        color = KRPGTheme.dangerColor;
        text = 'Cancelled';
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
              label: 'Time',
              value: training.formattedTime,
              icon: KRPGIcons.time,
            ),
            KRPGSpacing.horizontalMD,
            if (training.location != null)
              _buildDetailItem(
                label: 'Location',
                value: training.location!.locationName,
                icon: KRPGIcons.location,
              ),
          ],
        ),
        KRPGSpacing.verticalSM,
        Row(
          children: [
            if (training.coachName != null)
              _buildDetailItem(
                label: 'Coach',
                value: training.coachName!,
                icon: KRPGIcons.coach,
              ),
            KRPGSpacing.horizontalMD,
            _buildDetailItem(
              label: 'Date',
              value: training.formattedDate,
              icon: KRPGIcons.date,
            ),
          ],
        ),
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

  Widget _buildActions() {
    final List<Widget> actions = [];

    // Primary actions are added last to appear on the right.
    Widget? primaryAction;
    if (onJoin != null && training.status == TrainingStatus.active) {
      primaryAction = KRPGButton.primary(
        text: 'Join',
        size: KRPGButtonSize.small,
        onPressed: onJoin,
      );
    } else if (onMarkAttendance != null && training.canStart) {
      primaryAction = KRPGButton.success(
        text: 'Attendance',
        size: KRPGButtonSize.small,
        onPressed: onMarkAttendance,
      );
    }

    if (primaryAction != null) {
      if (actions.isNotEmpty) {
        actions.add(KRPGSpacing.horizontalXS);
      }
      actions.add(primaryAction);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }
} 