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

class CompetitionCertificateCard extends StatelessWidget {
  final CompetitionCertificate certificate;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const CompetitionCertificateCard({
    Key? key,
    required this.certificate,
    this.onTap,
    this.onDownload,
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
          if (showActions && onDownload != null) ...[
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
          KRPGIcons.trophy,
          color: _getCertificateColor(),
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                certificate.athleteName ?? 'Certificate',
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              KRPGSpacing.verticalXXS,
              Text(
                certificate.competitionName ?? 'Competition',
                style: KRPGTextStyles.bodyMediumSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        KRPGSpacing.horizontalSM,
        _buildTypeBadge(),
      ],
    );
  }

  Color _getCertificateColor() {
    switch (certificate.certificateType) {
      case CertificateType.winner:
        return Colors.amber; // Gold
      case CertificateType.achievement:
        return KRPGTheme.primaryColor; // Primary
      case CertificateType.participation:
        return KRPGTheme.neutralMedium; // Neutral
    }
  }

  Widget _buildTypeBadge() {
    Color color;
    String text;
    
    switch (certificate.certificateType) {
      case CertificateType.winner:
        color = Colors.amber;
        text = 'Winner';
        break;
      case CertificateType.achievement:
        color = KRPGTheme.primaryColor;
        text = 'Achievement';
        break;
      case CertificateType.participation:
        color = KRPGTheme.neutralMedium;
        text = 'Participation';
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
              label: 'Type',
              value: certificate.displayType,
              icon: KRPGIcons.trophy,
            ),
            KRPGSpacing.horizontalMD,
            _buildDetailItem(
              label: 'Upload Date',
              value: _formatDate(certificate.uploadDate),
              icon: KRPGIcons.date,
            ),
          ],
        ),
        KRPGSpacing.verticalSM,
        Row(
          children: [
            _buildDetailItem(
              label: 'Uploaded By',
              value: certificate.displayUploader,
              icon: KRPGIcons.person,
            ),
            KRPGSpacing.horizontalMD,
            if (certificate.competitionDate != null)
              _buildDetailItem(
                label: 'Competition Date',
                value: _formatDate(certificate.competitionDate!),
                icon: KRPGIcons.calendar,
              ),
          ],
        ),
        if (certificate.notes != null && certificate.notes!.isNotEmpty) ...[
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
          certificate.notes!,
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
        KRPGButton.primary(
          text: 'Download',
          icon: KRPGIcons.download,
          size: KRPGButtonSize.small,
          onPressed: onDownload,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
} 