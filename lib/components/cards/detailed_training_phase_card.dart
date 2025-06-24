import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/training_phase_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';

class DetailedTrainingPhaseCard extends StatefulWidget {
  final TrainingPhase phase;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;

  const DetailedTrainingPhaseCard({
    Key? key,
    required this.phase,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DetailedTrainingPhaseCard> createState() => _DetailedTrainingPhaseCardState();
}

class _DetailedTrainingPhaseCardState extends State<DetailedTrainingPhaseCard> {
  bool _isBasicInfoExpanded = true;
  bool _isDescriptionExpanded = true;
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
          _buildDescriptionSection(),
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
          KRPGIcons.training,
          color: KRPGTheme.primaryColor,
          size: 32,
        ),
        KRPGSpacing.horizontalMD,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.phase.phaseName,
                style: KRPGTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXS,
              Text(
                'Phase ID: ${widget.phase.id}',
                style: KRPGTextStyles.bodyMediumSecondary,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildDurationBadge(),
      ],
    );
  }

  Widget _buildDurationBadge() {
    final weeks = widget.phase.durationWeeks;
    String text;
    Color color;
    
    if (weeks <= 4) {
      text = '${weeks}w';
      color = KRPGTheme.successColor;
    } else if (weeks <= 8) {
      text = '${weeks}w';
      color = KRPGTheme.warningColor;
    } else {
      text = '${weeks}w';
      color = KRPGTheme.infoColor;
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
          Icon(Icons.schedule, size: 16, color: color),
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
        _buildInfoRow('Phase Name', widget.phase.phaseName),
        _buildInfoRow('Duration', '${widget.phase.durationWeeks} weeks'),
        _buildInfoRow('Duration (Days)', '${widget.phase.durationWeeks * 7} days'),
        _buildInfoRow('Is Deleted', widget.phase.isDeleted ? 'Yes' : 'No'),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return _buildCollapsibleSection(
      title: 'Description',
      icon: KRPGIcons.info,
      isExpanded: _isDescriptionExpanded,
      onToggle: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
      children: [
        if (widget.phase.description != null && widget.phase.description!.isNotEmpty)
          _buildInfoRow('Description', widget.phase.description!)
        else
          _buildInfoRow('Description', 'No description provided'),
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
        _buildInfoRow('Phase ID', widget.phase.id),
        _buildInfoRow('Duration Weeks', widget.phase.durationWeeks.toString()),
        _buildInfoRow('Is Deleted', widget.phase.isDeleted ? 'Yes' : 'No'),
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
} 