import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/training_session_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:intl/intl.dart';

class TrainingSessionCard extends StatelessWidget {
  final TrainingSession session;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const TrainingSessionCard({
    Key? key,
    required this.session,
    this.onTap,
    this.onStart,
    this.onEnd,
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
          if (showActions && (onStart != null || onEnd != null)) ...[
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
          KRPGIcons.stopwatch,
          color: KRPGTheme.primaryColor,
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.trainingTitle ?? 'Training Session',
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXXS,
              Text(
                'Session ID: ${session.id}',
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
    
    switch (session.status) {
      case TrainingSessionStatus.attendance:
        color = KRPGTheme.infoColor;
        text = 'Taking Attendance';
        break;
      case TrainingSessionStatus.recording:
        color = KRPGTheme.warningColor;
        text = 'Recording';
        break;
      case TrainingSessionStatus.completed:
        color = KRPGTheme.successColor;
        text = 'Completed';
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
              label: 'Schedule',
              value: _formatDate(session.scheduleDate),
              icon: KRPGIcons.date,
            ),
            KRPGSpacing.horizontalMD,
            _buildDetailItem(
              label: 'Time',
              value: '${session.startTime} - ${session.endTime}',
              icon: KRPGIcons.time,
            ),
          ],
        ),
        KRPGSpacing.verticalSM,
        Row(
          children: [
            if (session.coachName != null)
              _buildDetailItem(
                label: 'Coach',
                value: session.coachName!,
                icon: KRPGIcons.coach,
              ),
            KRPGSpacing.horizontalMD,
            if (session.attendeeCount != null)
              _buildDetailItem(
                label: 'Attendees',
                value: '${session.attendeeCount} athletes',
                icon: KRPGIcons.athlete,
              ),
          ],
        ),
        if (session.isStarted) ...[
          KRPGSpacing.verticalSM,
          Row(
            children: [
              _buildDetailItem(
                label: 'Started',
                value: _formatTime(session.startedAt!),
                icon: KRPGIcons.play,
              ),
              if (session.endedAt != null) ...[
                KRPGSpacing.horizontalMD,
                _buildDetailItem(
                  label: 'Ended',
                  value: _formatTime(session.endedAt!),
                  icon: KRPGIcons.stop,
                ),
              ],
            ],
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

  Widget _buildActions() {
    final List<Widget> actions = [];

    if (session.status == TrainingSessionStatus.attendance && onStart != null) {
      actions.add(
        KRPGButton.primary(
          text: 'Start Session',
          icon: KRPGIcons.play,
          size: KRPGButtonSize.small,
          onPressed: onStart,
        ),
      );
    }

    if (session.status == TrainingSessionStatus.recording && onEnd != null) {
      actions.add(
        KRPGButton.danger(
          text: 'End Session',
          icon: KRPGIcons.stop,
          size: KRPGButtonSize.small,
          onPressed: onEnd,
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
} 