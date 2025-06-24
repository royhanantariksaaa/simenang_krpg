import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/competition_model.dart';
import 'krpg_card.dart';
import '../ui/krpg_badge.dart';
import '../buttons/krpg_button.dart';
import '../../design_system/krpg_design_system.dart';

class CompetitionCard extends StatelessWidget {
  final Competition competition;
  final VoidCallback? onTap;
  final VoidCallback? onRegister;
  final VoidCallback? onUploadCertificate;
  final bool showActions;
  final bool isCompact;
  final bool isSelected;

  const CompetitionCard({
    super.key,
    required this.competition,
    this.onTap,
    this.onRegister,
    this.onUploadCertificate,
    this.showActions = true,
    this.isCompact = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return KRPGCard.competition(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (competition.image != null && !isCompact)
            _buildImage(),
          _buildHeader(),
          if (!isCompact) ...[
            KRPGSpacing.verticalSM,
            _buildDetails(),
          ],
          if (competition.description != null && !isCompact) ...[
            KRPGSpacing.verticalSM,
            _buildDescription(),
          ],
          if (showActions && (onRegister != null || onUploadCertificate != null)) ...[
            KRPGSpacing.verticalMD,
            _buildActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: competition.image!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          KRPGIcons.competition,
          color: KRPGTheme.accentColor,
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                competition.competitionName,
                style: KRPGTextStyles.cardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (competition.organizer != null) ...[
                KRPGSpacing.verticalXXS,
                Text(
                  'by ${competition.organizer}',
                  style: KRPGTextStyles.bodyMediumSecondary,
                  maxLines: 1,
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

  Widget _buildDetails() {
    return Column(
      children: [
        Row(
          children: [
            _buildDetailItem(
              label: 'Date',
              value: competition.formattedDate,
              icon: KRPGIcons.date,
            ),
            KRPGSpacing.horizontalMD,
            if (competition.location != null)
              _buildDetailItem(
                label: 'Location',
                value: competition.location!,
                icon: KRPGIcons.location,
              ),
          ],
        ),
        if (!isCompact) ...[
          KRPGSpacing.verticalSM,
          Row(
            children: [
              if (competition.endRegisterTime != null)
                _buildDetailItem(
                  label: 'Registration Deadline',
                  value: '${competition.endRegisterTime!.day}/${competition.endRegisterTime!.month}/${competition.endRegisterTime!.year}',
                  icon: KRPGIcons.time,
                ),
              KRPGSpacing.horizontalMD,
              if (competition.prize != null)
                _buildDetailItem(
                  label: 'Prize',
                  value: competition.prize!,
                  icon: KRPGIcons.medal,
                ),
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

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        competition.description!,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
          height: 1.4,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActions() {
    final List<Widget> actions = [];

    // Secondary actions are added first.
    if (onUploadCertificate != null && competition.status == CompetitionStatus.finished) {
      if (actions.isNotEmpty) actions.add(KRPGSpacing.horizontalXS);
      actions.add(KRPGButton.primary(
        text: 'Upload Certificate',
        size: KRPGButtonSize.small,
        onPressed: onUploadCertificate,
      ));
    }

    // Primary action is added last.
    if (onRegister != null && competition.isRegistrationOpen) {
      if (actions.isNotEmpty) actions.add(KRPGSpacing.horizontalXS);
      actions.add(KRPGButton.primary(
        text: 'Register',
        size: KRPGButtonSize.small,
        onPressed: onRegister,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    
    switch (competition.status) {
      case CompetitionStatus.comingSoon:
        color = KRPGTheme.infoColor;
        text = 'Coming Soon';
        break;
      case CompetitionStatus.ongoing:
        color = KRPGTheme.primaryColor;
        text = 'Ongoing';
        break;
      case CompetitionStatus.finished:
        color = KRPGTheme.neutralMedium;
        text = 'Finished';
        break;
      case CompetitionStatus.cancelled:
        color = KRPGTheme.dangerColor;
        text = 'Cancelled';
        break;
      case CompetitionStatus.inactive:
        color = KRPGTheme.neutralLight;
        text = 'Inactive';
        break;
    }

    return KRPGBadge(
      text: text,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      fontSize: KRPGTheme.fontSizeXs,
    );
  }
} 