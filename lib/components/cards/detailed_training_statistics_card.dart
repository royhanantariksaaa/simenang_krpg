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

class DetailedTrainingStatisticsCard extends StatefulWidget {
  final TrainingStatistics statistics;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;

  const DetailedTrainingStatisticsCard({
    Key? key,
    required this.statistics,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DetailedTrainingStatisticsCard> createState() => _DetailedTrainingStatisticsCardState();
}

class _DetailedTrainingStatisticsCardState extends State<DetailedTrainingStatisticsCard> {
  bool _isAthleteInfoExpanded = true;
  bool _isPerformanceExpanded = true;
  bool _isTrainingInfoExpanded = false;
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
          _buildAthleteInfoSection(),
          KRPGSpacing.verticalSM,
          _buildPerformanceSection(),
          KRPGSpacing.verticalSM,
          _buildTrainingInfoSection(),
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
          KRPGIcons.chart,
          color: KRPGTheme.primaryColor,
          size: 32,
        ),
        KRPGSpacing.horizontalMD,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.statistics.athleteName ?? 'Training Statistics',
                style: KRPGTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXS,
              Text(
                'Statistics ID: ${widget.statistics.id}',
                style: KRPGTextStyles.bodyMediumSecondary,
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
    
    if (widget.statistics.energySystem.contains('aerobic')) {
      color = KRPGTheme.successColor;
      text = 'Aerobic';
    } else if (widget.statistics.energySystem.contains('anaerobic')) {
      color = KRPGTheme.warningColor;
      text = 'Anaerobic';
    } else if (widget.statistics.energySystem.contains('vo2max')) {
      color = KRPGTheme.infoColor;
      text = 'VO2 Max';
    } else {
      color = KRPGTheme.neutralMedium;
      text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: KRPGTextStyles.labelMedium.copyWith(color: color),
      ),
    );
  }

  Widget _buildAthleteInfoSection() {
    return _buildCollapsibleSection(
      title: 'Athlete Information',
      icon: KRPGIcons.athlete,
      isExpanded: _isAthleteInfoExpanded,
      onToggle: () => setState(() => _isAthleteInfoExpanded = !_isAthleteInfoExpanded),
      children: [
        _buildInfoRow('Athlete Name', widget.statistics.athleteName ?? 'Not specified'),
        _buildInfoRow('Profile ID', widget.statistics.profileId),
        _buildInfoRow('Attendance ID', widget.statistics.attendanceId),
      ],
    );
  }

  Widget _buildPerformanceSection() {
    return _buildCollapsibleSection(
      title: 'Performance Metrics',
      icon: KRPGIcons.swimming,
      isExpanded: _isPerformanceExpanded,
      onToggle: () => setState(() => _isPerformanceExpanded = !_isPerformanceExpanded),
      children: [
        _buildInfoRow('Stroke', widget.statistics.stroke),
        if (widget.statistics.duration != null)
          _buildInfoRow('Duration', widget.statistics.duration!),
        if (widget.statistics.distance != null)
          _buildInfoRow('Distance', '${widget.statistics.distance}m'),
        if (widget.statistics.distanceInMeters != null)
          _buildInfoRow('Distance (m)', '${widget.statistics.distanceInMeters!.toStringAsFixed(1)}m'),
        if (widget.statistics.durationInSeconds != null)
          _buildInfoRow('Duration (sec)', '${widget.statistics.durationInSeconds!.inSeconds}s'),
        if (widget.statistics.pace != null)
          _buildInfoRow('Pace', '${widget.statistics.pace!.toStringAsFixed(2)} min/100m'),
        _buildInfoRow('Energy System', widget.statistics.energySystem.replaceAll('_', ' ').toUpperCase()),
      ],
    );
  }

  Widget _buildTrainingInfoSection() {
    return _buildCollapsibleSection(
      title: 'Training Information',
      icon: KRPGIcons.training,
      isExpanded: _isTrainingInfoExpanded,
      onToggle: () => setState(() => _isTrainingInfoExpanded = !_isTrainingInfoExpanded),
      children: [
        if (widget.statistics.trainingTitle != null)
          _buildInfoRow('Training Title', widget.statistics.trainingTitle!),
        if (widget.statistics.trainingDate != null)
          _buildInfoRow('Training Date', _formatDate(widget.statistics.trainingDate!)),
        if (widget.statistics.note != null && widget.statistics.note!.isNotEmpty)
          _buildInfoRow('Notes', widget.statistics.note!),
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
        _buildInfoRow('Statistics ID', widget.statistics.id),
        _buildInfoRow('Attendance ID', widget.statistics.attendanceId),
        _buildInfoRow('Profile ID', widget.statistics.profileId),
        _buildInfoRow('Is Deleted', widget.statistics.isDeleted ? 'Yes' : 'No'),
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