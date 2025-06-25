import 'package:flutter/material.dart';
import '../../design_system/krpg_theme.dart';
import '../../config/app_config.dart';

class DummyDataIndicator extends StatelessWidget {
  final bool isFloating;
  
  const DummyDataIndicator({
    super.key,
    this.isFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.showDummyDataIndicator || !AppConfig.isDummyDataForUEQSTest) {
      return const SizedBox.shrink();
    }

    if (isFloating) {
      return Positioned(
        top: 50,
        right: 16,
        child: _buildIndicatorCard(),
      );
    }

    return _buildIndicatorCard();
  }

  Widget _buildIndicatorCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KRPGTheme.warningColor.withOpacity(0.9),
            KRPGTheme.warmAmber.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
        boxShadow: KRPGTheme.shadowMedium,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KRPGTheme.spacingMd,
          vertical: KRPGTheme.spacingSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.science,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: KRPGTheme.spacingXs),
                Text(
                  'UEQ-S Testing Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: KRPGTheme.fontSizeXs,
                    fontWeight: KRPGTheme.fontWeightSemiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: KRPGTheme.spacingXs),
            Text(
              'Menggunakan data dummy untuk pengujian\nUser Experience Questionnaire',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: KRPGTheme.fontSizeXs - 1,
                height: 1.2,
              ),
            ),
            const SizedBox(height: KRPGTheme.spacingXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: KRPGTheme.spacingXs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(KRPGTheme.radiusXs),
              ),
              child: Text(
                'Role: ${AppConfig.dummyUserRole.toUpperCase()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: KRPGTheme.fontSizeXs - 2,
                  fontWeight: KRPGTheme.fontWeightMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyDataBanner extends StatelessWidget {
  const DummyDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.showDummyDataIndicator || !AppConfig.isDummyDataForUEQSTest) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: KRPGTheme.spacingMd,
        vertical: KRPGTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KRPGTheme.infoColor.withOpacity(0.1),
            KRPGTheme.tealAccent.withOpacity(0.05),
          ],
        ),
        border: Border(
          left: BorderSide(
            color: KRPGTheme.infoColor,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: KRPGTheme.infoColor,
            size: 20,
          ),
          const SizedBox(width: KRPGTheme.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Pengujian UEQ-S Aktif',
                  style: TextStyle(
                    color: KRPGTheme.textDark,
                    fontSize: KRPGTheme.fontSizeSm,
                    fontWeight: KRPGTheme.fontWeightSemiBold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Aplikasi menggunakan data simulasi untuk evaluasi pengalaman pengguna',
                  style: TextStyle(
                    color: KRPGTheme.textMedium,
                    fontSize: KRPGTheme.fontSizeXs,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: KRPGTheme.spacingSm,
              vertical: KRPGTheme.spacingXs,
            ),
            decoration: BoxDecoration(
              color: KRPGTheme.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(KRPGTheme.radiusXs),
              border: Border.all(
                color: KRPGTheme.infoColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'v${AppConfig.ueqsTestVersion}',
              style: TextStyle(
                color: KRPGTheme.infoColor,
                fontSize: KRPGTheme.fontSizeXs,
                fontWeight: KRPGTheme.fontWeightMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DummyDataDialog extends StatelessWidget {
  const DummyDataDialog({super.key});

  static void show(BuildContext context) {
    if (!AppConfig.isDummyDataForUEQSTest) return;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const DummyDataDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KRPGTheme.radiusLg),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(KRPGTheme.spacingSm),
            decoration: BoxDecoration(
              color: KRPGTheme.primaryGreenLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
            ),
            child: Icon(
              Icons.science,
              color: KRPGTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: KRPGTheme.spacingSm),
          Text(
            'Mode Pengujian UEQ-S',
            style: TextStyle(
              color: KRPGTheme.textDark,
              fontSize: KRPGTheme.fontSizeLg,
              fontWeight: KRPGTheme.fontWeightBold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang di versi pengujian SiMenang KRPG!',
            style: TextStyle(
              color: KRPGTheme.textDark,
              fontSize: KRPGTheme.fontSizeMd,
              fontWeight: KRPGTheme.fontWeightSemiBold,
            ),
          ),
          const SizedBox(height: KRPGTheme.spacingSm),
          Text(
            'Aplikasi ini menggunakan data simulasi yang realistis untuk keperluan evaluasi User Experience Questionnaire (UEQ-S).',
            style: TextStyle(
              color: KRPGTheme.textMedium,
              fontSize: KRPGTheme.fontSizeSm,
              height: 1.4,
            ),
          ),
          const SizedBox(height: KRPGTheme.spacingMd),
          Container(
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            decoration: BoxDecoration(
              color: KRPGTheme.backgroundAccent,
              borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
              border: Border.all(
                color: KRPGTheme.borderColorGreen,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fitur yang Tersedia:',
                  style: TextStyle(
                    color: KRPGTheme.textDark,
                    fontSize: KRPGTheme.fontSizeSm,
                    fontWeight: KRPGTheme.fontWeightSemiBold,
                  ),
                ),
                const SizedBox(height: KRPGTheme.spacingSm),
                ...['Dashboard dengan statistik lengkap', 'Manajemen ${AppConfig.mockAthletes} atlet dummy', 'Jadwal ${AppConfig.mockTrainingSessions} sesi latihan', '${AppConfig.mockCompetitions} kompetisi mendatang', 'Sistem absensi interaktif', 'Profil pengguna sebagai ${AppConfig.dummyUserRole}'].map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: KRPGTheme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: KRPGTheme.spacingSm),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            color: KRPGTheme.textMedium,
                            fontSize: KRPGTheme.fontSizeXs,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: KRPGTheme.spacingSm),
          Text(
            'Silakan jelajahi semua fitur untuk memberikan evaluasi yang komprehensif.',
            style: TextStyle(
              color: KRPGTheme.textMedium,
              fontSize: KRPGTheme.fontSizeSm,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Mulai Eksplorasi',
            style: TextStyle(
              color: KRPGTheme.primaryColor,
              fontWeight: KRPGTheme.fontWeightSemiBold,
            ),
          ),
        ),
      ],
    );
  }
} 