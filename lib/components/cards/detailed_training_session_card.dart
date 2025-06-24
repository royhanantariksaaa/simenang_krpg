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

class DetailedTrainingSessionCard extends StatefulWidget {
  final TrainingSession session;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;

  const DetailedTrainingSessionCard({
    Key? key,
    required this.session,
    this.onTap,
    this.onStart,
    this.onEnd,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DetailedTrainingSessionCard> createState() => _DetailedTrainingSessionCardState();
}

class _DetailedTrainingSessionCardState extends State<DetailedTrainingSessionCard> {
  bool _isBasicInfoExpanded = true;
  bool _isScheduleExpanded = true;
  bool _isProgressExpanded = false;
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
          _buildScheduleSection(),
          KRPGSpacing.verticalSM,
          _buildProgressSection(),
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
        Icon(
          KRPGIcons.stopwatch,
          color: KRPGTheme.primaryColor,
          size: 32,
        ),
        KRPGSpacing.horizontalMD,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.session.trainingTitle ?? 'Training Session',
                style: KRPGTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXS,
              Text(
                'Session ID: ${widget.session.id}',
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
    Color color;
    String text;
    IconData icon;
    
    switch (widget.session.status) {
      case TrainingSessionStatus.attendance:
        color = KRPGTheme.infoColor;
        text = 'Taking Attendance';
        icon = Icons.how_to_reg_rounded;
        break;
      case TrainingSessionStatus.recording:
        color = KRPGTheme.warningColor;
        text = 'Recording';
        icon = Icons.timer_rounded;
        break;
      case TrainingSessionStatus.completed:
        color = KRPGTheme.successColor;
        text = 'Completed';
        icon = Icons.check_circle_outline_rounded;
        break;
    }

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
        _buildInfoRow('Training ID', widget.session.trainingId),
        if (widget.session.coachName != null)
          _buildInfoRow('Coach', widget.session.coachName!),
        if (widget.session.attendeeCount != null)
          _buildInfoRow('Attendees', '${widget.session.attendeeCount} athletes'),
        _buildInfoRow('Created By', widget.session.createdById),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return _buildCollapsibleSection(
      title: 'Schedule & Timing',
      icon: KRPGIcons.calendar,
      isExpanded: _isScheduleExpanded,
      onToggle: () => setState(() => _isScheduleExpanded = !_isScheduleExpanded),
      children: [
        _buildInfoRow('Schedule Date', _formatDate(widget.session.scheduleDate)),
        _buildInfoRow('Start Time', widget.session.startTime),
        _buildInfoRow('End Time', widget.session.endTime),
        _buildInfoRow('Duration', _calculateDuration()),
      ],
    );
  }

  Widget _buildProgressSection() {
    return _buildCollapsibleSection(
      title: 'Progress & Timing',
      icon: KRPGIcons.chart,
      isExpanded: _isProgressExpanded,
      onToggle: () => setState(() => _isProgressExpanded = !_isProgressExpanded),
      children: [
        _buildInfoRow('Started', widget.session.isStarted ? _formatDateTime(widget.session.startedAt!) : 'Not started'),
        if (widget.session.endedAt != null)
          _buildInfoRow('Ended', _formatDateTime(widget.session.endedAt!)),
        if (widget.session.duration != null)
          _buildInfoRow('Actual Duration', _formatDuration(widget.session.duration!)),
        _buildInfoRow('Status', widget.session.status.displayName),
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
        _buildInfoRow('Session ID', widget.session.id),
        _buildInfoRow('Training ID', widget.session.trainingId),
        _buildInfoRow('Created Date', _formatDateTime(widget.session.createDate)),
        _buildInfoRow('Created By ID', widget.session.createdById),
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
            width: 120,
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

    if (widget.session.status == TrainingSessionStatus.attendance && widget.onStart != null) {
      actions.add(
        KRPGButton.primary(
          text: 'Start Session',
          icon: KRPGIcons.play,
          onPressed: widget.onStart,
        ),
      );
    }

    if (widget.session.status == TrainingSessionStatus.recording && widget.onEnd != null) {
      actions.add(
        KRPGButton.danger(
          text: 'End Session',
          icon: KRPGIcons.stop,
          onPressed: widget.onEnd,
        ),
      );
    }

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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  String _calculateDuration() {
    final start = widget.session.startTime;
    final end = widget.session.endTime;
    if (start == null || end == null) return 'Not specified';
    
    try {
      final startParts = start.split(':');
      final endParts = end.split(':');
      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
      final durationMinutes = endMinutes - startMinutes;
      
      if (durationMinutes <= 0) return 'Invalid time range';
      
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${minutes}m';
      }
    } catch (e) {
      return 'Invalid time format';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
} 