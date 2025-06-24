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

class DetailedCompetitionResultCard extends StatefulWidget {
  final CompetitionResult result;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;

  const DetailedCompetitionResultCard({
    Key? key,
    required this.result,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DetailedCompetitionResultCard> createState() => _DetailedCompetitionResultCardState();
}

class _DetailedCompetitionResultCardState extends State<DetailedCompetitionResultCard> {
  bool _isAthleteInfoExpanded = true;
  bool _isPerformanceExpanded = true;
  bool _isCompetitionInfoExpanded = false;
  bool _isMetadataExpanded = false;

  @override
  Widget build(BuildContext context) {
    return KRPGCard.competition(
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
          _buildCompetitionInfoSection(),
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
          KRPGIcons.medal,
          color: KRPGTheme.primaryColor,
          size: 32,
        ),
        KRPGSpacing.horizontalMD,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.result.athleteName ?? 'Competition Result',
                style: KRPGTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXS,
              Text(
                'Result ID: ${widget.result.id}',
                style: KRPGTextStyles.bodyMediumSecondary,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildResultStatusBadge(),
      ],
    );
  }

  Widget _buildResultStatusBadge() {
    Color color;
    String text;
    IconData icon;
    
    switch (widget.result.resultStatus) {
      case CompetitionResultStatus.completed:
        color = KRPGTheme.successColor;
        text = 'Completed';
        icon = Icons.check_circle_outline_rounded;
        break;
      case CompetitionResultStatus.dns:
        color = KRPGTheme.warningColor;
        text = 'DNS';
        icon = Icons.cancel_outlined;
        break;
      case CompetitionResultStatus.dnf:
        color = KRPGTheme.dangerColor;
        text = 'DNF';
        icon = Icons.error_outline_rounded;
        break;
      case CompetitionResultStatus.dq:
        color = KRPGTheme.dangerColor;
        text = 'DQ';
        icon = Icons.block_rounded;
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

  Widget _buildAthleteInfoSection() {
    return _buildCollapsibleSection(
      title: 'Athlete Information',
      icon: KRPGIcons.athlete,
      isExpanded: _isAthleteInfoExpanded,
      onToggle: () => setState(() => _isAthleteInfoExpanded = !_isAthleteInfoExpanded),
      children: [
        _buildInfoRow('Athlete Name', widget.result.athleteName ?? 'Not specified'),
        _buildInfoRow('Registration ID', widget.result.registeredParticipantId),
      ],
    );
  }

  Widget _buildPerformanceSection() {
    return _buildCollapsibleSection(
      title: 'Performance Results',
      icon: KRPGIcons.chart,
      isExpanded: _isPerformanceExpanded,
      onToggle: () => setState(() => _isPerformanceExpanded = !_isPerformanceExpanded),
      children: [
        if (widget.result.position != null)
          _buildInfoRow('Position', '${widget.result.position}${_getPositionSuffix(widget.result.position!)}'),
        if (widget.result.timeResult != null && widget.result.timeResult!.isNotEmpty)
          _buildInfoRow('Time Result', widget.result.timeResult!),
        if (widget.result.points != null)
          _buildInfoRow('Points', widget.result.points!.toStringAsFixed(2)),
        _buildInfoRow('Result Status', widget.result.resultStatus.displayName),
        _buildInfoRow('Result Type', widget.result.resultType.displayName),
        if (widget.result.category != null && widget.result.category!.isNotEmpty)
          _buildInfoRow('Category', widget.result.category!),
        if (widget.result.notes != null && widget.result.notes!.isNotEmpty)
          _buildInfoRow('Notes', widget.result.notes!),
      ],
    );
  }

  Widget _buildCompetitionInfoSection() {
    return _buildCollapsibleSection(
      title: 'Competition Information',
      icon: KRPGIcons.competition,
      isExpanded: _isCompetitionInfoExpanded,
      onToggle: () => setState(() => _isCompetitionInfoExpanded = !_isCompetitionInfoExpanded),
      children: [
        if (widget.result.competitionName != null)
          _buildInfoRow('Competition', widget.result.competitionName!),
        if (widget.result.competitionDate != null)
          _buildInfoRow('Competition Date', _formatDate(widget.result.competitionDate!)),
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
        _buildInfoRow('Result ID', widget.result.id),
        _buildInfoRow('Registration ID', widget.result.registeredParticipantId),
        _buildInfoRow('Created Date', _formatDateTime(widget.result.createDate)),
        _buildInfoRow('Created By ID', widget.result.createdById),
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  String _getPositionSuffix(int position) {
    if (position == 1) return 'st';
    if (position == 2) return 'nd';
    if (position == 3) return 'rd';
    return 'th';
  }
} 