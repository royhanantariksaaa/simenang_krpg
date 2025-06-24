import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/competition_certificate_model.dart';
import 'package:simenang_krpg/components/ui/krpg_badge.dart';
import 'package:simenang_krpg/components/buttons/krpg_button.dart';
import 'package:simenang_krpg/design_system/krpg_icons.dart';
import 'package:intl/intl.dart';

class DetailedCompetitionCertificateCard extends StatefulWidget {
  final CompetitionCertificate certificate;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  final VoidCallback? onDownload;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;

  const DetailedCompetitionCertificateCard({
    Key? key,
    required this.certificate,
    this.onTap,
    this.onView,
    this.onDownload,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<DetailedCompetitionCertificateCard> createState() => _DetailedCompetitionCertificateCardState();
}

class _DetailedCompetitionCertificateCardState extends State<DetailedCompetitionCertificateCard> {
  bool _isAthleteInfoExpanded = true;
  bool _isCertificateInfoExpanded = true;
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
          _buildCertificateInfoSection(),
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
          KRPGIcons.trophy,
          color: KRPGTheme.primaryColor,
          size: 32,
        ),
        KRPGSpacing.horizontalMD,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.certificate.athleteName ?? 'Competition Certificate',
                style: KRPGTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXS,
              Text(
                'Certificate ID: ${widget.certificate.id}',
                style: KRPGTextStyles.bodyMediumSecondary,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildCertificateTypeBadge(),
      ],
    );
  }

  Widget _buildCertificateTypeBadge() {
    Color color;
    String text;
    IconData icon;
    
    switch (widget.certificate.certificateType) {
      case CertificateType.participation:
        color = KRPGTheme.infoColor;
        text = 'Participation';
        icon = Icons.emoji_events_outlined;
        break;
      case CertificateType.achievement:
        color = KRPGTheme.warningColor;
        text = 'Achievement';
        icon = Icons.star_outline_rounded;
        break;
      case CertificateType.winner:
        color = KRPGTheme.successColor;
        text = 'Winner';
        icon = Icons.military_tech_rounded;
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
        _buildInfoRow('Athlete Name', widget.certificate.athleteName ?? 'Not specified'),
        _buildInfoRow('Registration ID', widget.certificate.registeredParticipantId),
      ],
    );
  }

  Widget _buildCertificateInfoSection() {
    return _buildCollapsibleSection(
      title: 'Certificate Information',
      icon: KRPGIcons.trophy,
      isExpanded: _isCertificateInfoExpanded,
      onToggle: () => setState(() => _isCertificateInfoExpanded = !_isCertificateInfoExpanded),
      children: [
        _buildInfoRow('Certificate Type', widget.certificate.certificateType.displayName),
        if (widget.certificate.certificatePath != null && widget.certificate.certificatePath!.isNotEmpty)
          _buildInfoRow('File Path', widget.certificate.certificatePath!)
        else
          _buildInfoRow('File Path', 'Not available'),
        if (widget.certificate.notes != null && widget.certificate.notes!.isNotEmpty)
          _buildInfoRow('Notes', widget.certificate.notes!)
        else
          _buildInfoRow('Notes', 'No additional notes'),
        _buildInfoRow('Upload Date', _formatDateTime(widget.certificate.uploadDate)),
        _buildInfoRow('Uploaded By', widget.certificate.uploadedById),
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
        if (widget.certificate.competitionName != null)
          _buildInfoRow('Competition', widget.certificate.competitionName!),
        if (widget.certificate.competitionDate != null)
          _buildInfoRow('Competition Date', _formatDate(widget.certificate.competitionDate!)),
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
        _buildInfoRow('Certificate ID', widget.certificate.id),
        _buildInfoRow('Registration ID', widget.certificate.registeredParticipantId),
        _buildInfoRow('Is Deleted', widget.certificate.isDeleted ? 'Yes' : 'No'),
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

    if (widget.onView != null) {
      actions.add(
        KRPGButton.primary(
          text: 'View',
          icon: KRPGIcons.visible,
          onPressed: widget.onView,
        ),
      );
    }

    if (widget.onDownload != null) {
      actions.add(
        KRPGButton.secondary(
          text: 'Download',
          icon: KRPGIcons.download,
          onPressed: widget.onDownload,
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
} 