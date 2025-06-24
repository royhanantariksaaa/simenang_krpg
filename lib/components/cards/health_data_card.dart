import 'package:flutter/material.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_text_styles.dart';
import 'package:simenang_krpg/design_system/krpg_theme.dart';
import 'package:simenang_krpg/design_system/krpg_spacing.dart';
import 'package:simenang_krpg/models/health_data_model.dart';

class HealthDataCard extends StatelessWidget {
  final HealthData healthData;
  final VoidCallback? onTap;

  const HealthDataCard({
    Key? key,
    required this.healthData,
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
                'Health Data',
                style: KRPGTextStyles.heading3,
              ),
              if (healthData.lastUpdated != null)
                Text(
                  healthData.lastUpdated!.toString().split(' ')[0],
                  style: KRPGTextStyles.bodyMedium.copyWith(
                    color: KRPGTheme.textMedium,
                  ),
                ),
            ],
          ),
          KRPGSpacing.verticalMD,
          _buildHealthMetrics(),
          if (healthData.diseaseHistory != null ||
              healthData.allergies != null) ...[
            KRPGSpacing.verticalMD,
            _buildMedicalInfo(),
          ],
          if (healthData.bmi != null) ...[
            KRPGSpacing.verticalMD,
            _buildBMIInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildHealthMetrics() {
    return Row(
      children: [
        if (healthData.height != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetric('Height', '${healthData.height} cm'),
              ],
            ),
          ),
        if (healthData.weight != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetric('Weight', '${healthData.weight} kg'),
              ],
            ),
          ),
        if (healthData.bloodType != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetric('Blood Type', healthData.bloodType!),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMedicalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (healthData.diseaseHistory != null && healthData.diseaseHistory!.isNotEmpty) ...[
          Text(
            'Disease History',
            style: KRPGTextStyles.cardTitle,
          ),
          KRPGSpacing.verticalXS,
          ...healthData.diseaseHistory!.map((disease) => 
            Padding(
              padding: KRPGSpacing.paddingVerticalXXS,
              child: Text(
                disease,
                style: KRPGTextStyles.bodyMedium,
              ),
            ),
          ),
        ],
        if (healthData.allergies != null && healthData.allergies!.isNotEmpty) ...[
          KRPGSpacing.verticalSM,
          Text(
            'Allergies',
            style: KRPGTextStyles.cardTitle,
          ),
          KRPGSpacing.verticalXS,
          ...healthData.allergies!.map((allergy) => 
            Padding(
              padding: KRPGSpacing.paddingVerticalXXS,
              child: Text(
                allergy,
                style: KRPGTextStyles.bodyMedium,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBMIInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BMI',
          style: KRPGTextStyles.cardTitle,
        ),
        KRPGSpacing.verticalXS,
        Text(
          healthData.bmi!.toStringAsFixed(1),
          style: KRPGTextStyles.statNumber,
        ),
      ],
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: KRPGTextStyles.cardSubtitle,
        ),
        Text(
          value,
          style: KRPGTextStyles.cardTitle,
        ),
      ],
    );
  }
} 