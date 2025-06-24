import 'package:flutter/material.dart';
import '../../models/classroom_model.dart';
import '../ui/krpg_badge.dart';
import 'krpg_card.dart';
import '../../design_system/krpg_design_system.dart';

class ClassroomCard extends StatelessWidget {
  final Classroom classroom;
  final VoidCallback? onTap;
  final bool isSelected;

  const ClassroomCard({
    super.key,
    required this.classroom,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return KRPGCard.list(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          KRPGSpacing.verticalSM,
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          KRPGIcons.group,
          color: KRPGTheme.secondaryColor,
          size: 24,
        ),
        KRPGSpacing.horizontalSM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classroom.name,
                style: KRPGTextStyles.cardTitle,
              ),
              if (classroom.coach?.name != null)
                Text(
                  'Coached by ${classroom.coach!.name}',
                  style: KRPGTextStyles.bodySmallSecondary,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (classroom.studentCount != null)
          KRPGBadge(
            text: '${classroom.studentCount} Students',
            backgroundColor: KRPGTheme.secondaryColor.withOpacity(0.1),
            textColor: KRPGTheme.secondaryColor,
            icon: KRPGIcons.athlete,
          ),
      ],
    );
  }
} 