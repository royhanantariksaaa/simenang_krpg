import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;
  final VoidCallback? onTap;

  const AttendanceCard({
    Key? key,
    required this.attendance,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KRPGCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Record',
                style: KRPGTextStyles.heading3,
              ),
              _buildStatusBadge(),
            ],
          ),
          KRPGSpacing.verticalMD,
          _buildAttendanceInfo(),
          if (attendance.note != null && attendance.note!.isNotEmpty) ...[
            KRPGSpacing.verticalMD,
            _buildNotes(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: KRPGTheme.spacingXs,
        vertical: KRPGTheme.spacingXxs,
      ),
      decoration: BoxDecoration(
        color: attendance.status.displayColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            attendance.status.displayIcon,
            size: 16,
            color: attendance.status.displayColor,
          ),
          const SizedBox(width: 4),
          Text(
            attendance.status.displayName,
            style: KRPGTextStyles.labelMedium.copyWith(
              color: attendance.status.displayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: KRPGTextStyles.cardSubtitle,
        ),
        Text(
          _formatDateTime(attendance.dateTime),
          style: KRPGTextStyles.cardTitle,
        ),
        KRPGSpacing.verticalMD,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training',
                    style: KRPGTextStyles.cardSubtitle,
                  ),
                  Text(
                    attendance.trainingTitle ?? 'Session #${attendance.trainingSessionId}',
                    style: KRPGTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Athlete',
                    style: KRPGTextStyles.cardSubtitle,
                  ),
                  Text(
                    attendance.athleteName ?? 'ID: ${attendance.profileId}',
                    style: KRPGTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: KRPGTextStyles.cardSubtitle,
        ),
        KRPGSpacing.verticalXS,
        Text(
          attendance.note!,
          style: KRPGTextStyles.bodyMedium,
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 