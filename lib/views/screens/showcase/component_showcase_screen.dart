import 'package:flutter/material.dart';
import '../../../design_system/krpg_design_system.dart';
import '../../../models/athlete_model.dart';
import '../../../models/coach_model.dart';
import '../../../models/user_model.dart';
import '../../../models/training_model.dart' hide Location, TrainingSession, TrainingSessionStatus;
import '../../../models/competition_model.dart' hide AthleteLevel, CompetitionResult;
import '../../../models/invoice_model.dart';
import '../../../models/classroom_model.dart';
import '../../../models/training_session_model.dart';
import '../../../models/training_statistics_model.dart';
import '../../../models/training_phase_model.dart';
import '../../../models/profile_management_model.dart';
import '../../../models/competition_result_model.dart';
import '../../../models/competition_certificate_model.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/cards/training_card.dart';
import '../../../components/cards/competition_card.dart';
import '../../../components/cards/athlete_card.dart';
import '../../../components/cards/coach_card.dart';
import '../../../components/cards/invoice_card.dart';
import '../../../components/cards/classroom_card.dart';
import '../../../components/cards/training_session_card.dart';
import '../../../components/cards/training_statistics_card.dart';
import '../../../components/cards/training_phase_card.dart';
import '../../../components/cards/profile_management_card.dart';
import '../../../components/cards/competition_result_card.dart';
import '../../../components/cards/competition_certificate_card.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../components/buttons/krpg_button.dart';
import 'package:simenang_krpg/components/cards/location_card.dart';
import 'package:simenang_krpg/models/location_model.dart';
import 'detailed_components_showcase_screen.dart';

class ComponentShowcaseScreen extends StatelessWidget {
  const ComponentShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KRPG Components'),
        backgroundColor: KRPGTheme.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Dashboard Cards'),
          _buildDetailedShowcaseSection(context),
          _buildDashboardCards(),
          
          _buildSectionHeader('Buttons'),
          _buildButtons(),
          
          _buildSectionHeader('Badges'),
          _buildBadges(),
          
          _buildSectionHeader('Training Cards'),
          _buildTrainingCards(),
          
          _buildSectionHeader('Competition Cards'),
          _buildCompetitionCards(),

          _buildSectionHeader('Athlete Cards'),
          _buildAthleteCards(),

          _buildSectionHeader('Coach Cards'),
          _buildCoachCards(),
          
          _buildSectionHeader('Profile Management Cards'),
          _buildProfileManagementCards(),

          _buildSectionHeader('Invoice Cards'),
          _buildInvoiceCards(),

          _buildSectionHeader('Classroom Cards'),
          _buildClassroomCards(),

          _buildSectionHeader('Location Cards'),
          _buildLocationCards(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: KRPGTextStyles.heading4,
      ),
    );
  }

  Widget _buildDetailedShowcaseSection(BuildContext context) {
    return KRPGCard.dashboard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.dashboard_customize,
                color: KRPGTheme.primaryColor,
                size: 32,
              ),
              KRPGSpacing.horizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Components Showcase',
                      style: KRPGTextStyles.heading5,
                    ),
                    Text(
                      'Explore comprehensive card designs with collapsible sections, navigation components, and advanced filtering',
                      style: KRPGTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          KRPGSpacing.verticalMD,
          KRPGButton.primary(
            text: 'View Detailed Showcase',
            icon: Icons.arrow_forward,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailedComponentsShowcaseScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCards() {
    return Column(
      children: [
        KRPGCard.dashboard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    KRPGIcons.swimming, 
                    color: KRPGTheme.primaryColor,
                    size: 32,
                  ),
                  KRPGSpacing.horizontalMD,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: KRPGTextStyles.heading5,
                        ),
                        Text(
                          'Ready for your training session?',
                           style: KRPGTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              KRPGSpacing.verticalMD,
              KRPGButton.primary(
                text: 'View Schedule',
                icon: KRPGIcons.calendar,
                size: KRPGButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Primary Buttons'),
        KRPGSpacing.verticalSM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            KRPGButton.primary(text: 'Primary', onPressed: () {}),
            KRPGButton.primary(text: 'With Icon', icon: KRPGIcons.add, onPressed: () {}),
            KRPGButton.primary(text: 'Loading', isLoading: true, onPressed: () {}),
            KRPGButton.primary(text: 'Disabled', onPressed: null),
          ],
        ),
        KRPGSpacing.verticalMD,
        const Text('Secondary Buttons'),
        KRPGSpacing.verticalSM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            KRPGButton.secondary(text: 'Secondary', onPressed: () {}),
            KRPGButton.secondary(text: 'With Icon', icon: KRPGIcons.info, onPressed: () {}),
            KRPGButton.secondary(text: 'Loading', isLoading: true, onPressed: () {}),
            KRPGButton.secondary(text: 'Disabled', onPressed: null),
          ],
        ),
        KRPGSpacing.verticalMD,
        const Text('Success, Danger, and Other Buttons'),
        KRPGSpacing.verticalSM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            KRPGButton.success(text: 'Success', icon: KRPGIcons.success, onPressed: () {}),
            KRPGButton.danger(text: 'Danger', icon: KRPGIcons.error, onPressed: () {}),
            KRPGButton(text: 'Text Button', type: KRPGButtonType.text, onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        KRPGBadge(text: 'Default'),
        KRPGBadge.primary(text: 'Primary'),
        KRPGBadge.secondary(text: 'Secondary'),
        KRPGBadge.success(text: 'Success'),
        KRPGBadge.danger(text: 'Danger'),
        KRPGBadge.warning(text: 'Warning'),
        KRPGBadge.info(text: 'Info'),
        KRPGBadge(text: 'Custom', backgroundColor: Colors.teal, textColor: Colors.white),
      ],
    );
  }

  Widget _buildTrainingCards() {
    final training1 = Training(
      idTraining: '1',
      title: 'Morning Swim Practice',
      description: 'Focus on endurance and technique.',
      datetime: DateTime.now(),
      status: TrainingStatus.active,
      coachName: 'Coach Alex',
      location: null,
      startTime: '08:00',
      endTime: '10:00',
    );
    final training2 = Training(
      idTraining: '2',
      title: 'Evening Dry-land Workout',
      description: 'Strength and conditioning session.',
      datetime: DateTime.now().add(const Duration(days: 1)),
      status: TrainingStatus.inactive,
      coachName: 'Coach Sarah',
      location: null,
      startTime: '18:00',
      endTime: '19:30',
    );
    return Column(
      children: [
        TrainingCard(training: training1, onTap: () {}, onJoin: () {}),
        KRPGSpacing.verticalSM,
        TrainingCard(training: training2, onTap: () {}, isSelected: true),
      ],
    );
  }

  Widget _buildTrainingSessionCards() {
    final session1 = TrainingSession(
      id: 'TS001',
      trainingId: '1',
      scheduleDate: DateTime.now(),
      startTime: '08:00',
      endTime: '10:00',
      status: TrainingSessionStatus.attendance,
      createDate: DateTime.now(),
      createdById: 'coach1',
      trainingTitle: 'Morning Swim Practice',
      coachName: 'Coach Alex',
    );
    
    final session2 = TrainingSession(
      id: 'TS002',
      trainingId: '2',
      scheduleDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '18:00',
      endTime: '19:30',
      status: TrainingSessionStatus.recording,
      createDate: DateTime.now(),
      createdById: 'coach2',
      trainingTitle: 'Evening Dry-land Workout',
      coachName: 'Coach Sarah',
      startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    );
    
    return Column(
      children: [
        TrainingSessionCard(session: session1, onTap: () {}),
        KRPGSpacing.verticalSM,
        TrainingSessionCard(session: session2, onTap: () {}),
      ],
    );
  }
  
  Widget _buildTrainingStatisticsCards() {
    final stats1 = TrainingStatistics(
      id: 'STAT001',
      attendanceId: 'ATT001',
      profileId: 'P001',
      stroke: 'Freestyle',
      duration: '45:00',
      distance: '2000',
      energySystem: 'aerobic_11',
      note: 'Good technique, needs to work on breathing pattern.',
      athleteName: 'John Doe',
      trainingDate: DateTime.now().subtract(const Duration(days: 2)),
    );
    
    final stats2 = TrainingStatistics(
      id: 'STAT002',
      attendanceId: 'ATT002',
      profileId: 'P002',
      stroke: 'Butterfly',
      duration: '30:00',
      distance: '1500',
      energySystem: 'anaerobic_11',
      note: 'Excellent form, improving stroke efficiency.',
      athleteName: 'Jane Smith',
      trainingDate: DateTime.now().subtract(const Duration(days: 1)),
    );
    
    return Column(
      children: [
        TrainingStatisticsCard(statistics: stats1, onTap: () {}),
        KRPGSpacing.verticalSM,
        TrainingStatisticsCard(statistics: stats2, onTap: () {}),
      ],
    );
  }
  
  Widget _buildTrainingPhaseCards() {
    final phase1 = TrainingPhase(
      id: 'TP001',
      phaseName: 'Base Building',
      description: 'Focus on building aerobic capacity and technique fundamentals.',
      durationWeeks: 6,
      activeTrainings: 5,
      startDate: DateTime.now().subtract(const Duration(days: 14)),
      endDate: DateTime.now().add(const Duration(days: 28)),
    );
    
    final phase2 = TrainingPhase(
      id: 'TP002',
      phaseName: 'Competition Preparation',
      description: 'Increase intensity and specificity for upcoming competitions.',
      durationWeeks: 4,
      activeTrainings: 8,
      startDate: DateTime.now().add(const Duration(days: 28)),
      endDate: DateTime.now().add(const Duration(days: 56)),
    );
    
    return Column(
      children: [
        TrainingPhaseCard(phase: phase1, onTap: () {}),
        KRPGSpacing.verticalSM,
        TrainingPhaseCard(phase: phase2, onTap: () {}),
      ],
    );
  }
  
  Widget _buildProfileManagementCards() {
    final profile1 = ProfileManagement(
      id: 'PM001',
      accountId: 'A001',
      name: 'John Doe',
      birthDate: DateTime(2005, 5, 10),
      gender: Gender.male,
      phone: '123-456-7890',
      address: 'Jl. Gatot Subroto No. 123, Jakarta Selatan',
      profilePictureUrl: 'https://i.pravatar.cc/150?img=1',
      status: ProfileStatus.active,
    );
    
    final profile2 = ProfileManagement(
      id: 'PM002',
      accountId: 'A002',
      name: 'Jane Smith',
      birthDate: DateTime(2003, 8, 22),
      gender: Gender.female,
      phone: '098-765-4321',
      address: 'Jl. Sudirman No. 456, Jakarta Pusat',
      status: ProfileStatus.inactive,
    );
    
    return Column(
      children: [
        ProfileManagementCard(profile: profile1, onTap: () {}),
        KRPGSpacing.verticalSM,
        ProfileManagementCard(profile: profile2, onTap: () {}),
      ],
    );
  }

  Widget _buildCompetitionCards() {
    final competition1 = Competition(
      idCompetition: '1',
      competitionName: 'Regional Swimming Championship',
      organizer: 'Regional Swimming Association',
      description: 'Annual championship for all clubs in the region.',
      status: CompetitionStatus.comingSoon,
      location: 'City Aquatic Center',
      startTime: DateTime.now().add(const Duration(days: 30)),
      endTime: DateTime.now().add(const Duration(days: 32)),
      startRegisterTime: DateTime.now(),
      endRegisterTime: DateTime.now().add(const Duration(days: 15)),
      prize: 'Medals and Trophies',
    );
    final competition2 = Competition(
      idCompetition: '2',
      competitionName: 'Club-level Time Trials',
      organizer: 'KRPG Club',
      status: CompetitionStatus.finished,
      location: 'Main Pool',
      startTime: DateTime.now().subtract(const Duration(days: 10)),
    );
    return Column(
      children: [
        CompetitionCard(competition: competition1, onTap: () {}, onRegister: () {}),
        KRPGSpacing.verticalSM,
        CompetitionCard(competition: competition2, onTap: () {}, isSelected: true, onUploadCertificate: () {}),
      ],
    );
  }

  Widget _buildAthleteCards() {
    final athlete1 = Athlete(
      idAthlete: '1',
      idProfile: 'p1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      status: AthleteStatus.active,
      level: AthleteLevel.intermediate,
      birthDate: DateTime(2005, 5, 10),
      phone: '123-456-7890',
      specializations: [
        AthleteSpecialization(idSpecialization: '1', idAthlete: '1', name: 'Freestyle'),
        AthleteSpecialization(idSpecialization: '2', idAthlete: '1', name: 'Butterfly'),
      ],
    );
    final athlete2 = Athlete(
      idAthlete: '2',
      idProfile: 'p2',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      status: AthleteStatus.suspended,
      level: AthleteLevel.professional,
      birthDate: DateTime(2003, 8, 22),
      phone: '098-765-4321',
      specializations: [
        AthleteSpecialization(idSpecialization: '3', idAthlete: '2', name: 'Backstroke'),
      ],
    );
    return Column(
      children: [
        AthleteCard(athlete: athlete1, onTap: () {}),
        KRPGSpacing.verticalSM,
        AthleteCard(athlete: athlete2, onTap: () {}, isSelected: true),
      ],
    );
  }

  Widget _buildCoachCards() {
    final coach1 = Coach(
      idCoach: 'c1',
      idProfile: 'p3',
      name: 'Alex Johnson',
      email: 'alex.j@example.com',
      status: CoachStatus.active,
      experience: '10+ years',
      specialization: 'Competitive Swimming',
      phone: '555-123-4567',
      certifications: ['USA Swimming Level 3', 'ASCA Certified'],
    );
    final coach2 = Coach(
      idCoach: 'c2',
      idProfile: 'p4',
      name: 'Sarah Williams',
      email: 'sarah.w@example.com',
      status: CoachStatus.onLeave,
      experience: '5 years',
      specialization: 'Youth Development',
      phone: '555-987-6543',
      certifications: ['FINA Certified Coach'],
    );
    return Column(
      children: [
        CoachCard(coach: coach1, onTap: () {}),
        KRPGSpacing.verticalSM,
        CoachCard(coach: coach2, onTap: () {}, isSelected: true),
      ],
    );
  }

  Widget _buildInvoiceCards() {
    final invoice1 = Invoice(
      id: 'INV-001',
      payerId: 'p1',
      amount: 150000,
      status: InvoiceStatus.approved,
      category: InvoiceCategory.monthlyFee,
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      payerName: 'John Doe',
    );
    final invoice2 = Invoice(
      id: 'INV-002',
      payerId: 'p2',
      amount: 75000,
      status: InvoiceStatus.pending,
      category: InvoiceCategory.competitionFee,
      createdDate: DateTime.now(),
      payerName: 'Jane Smith',
    );
    return Column(
      children: [
        InvoiceCard(invoice: invoice1, onTap: () {}),
        KRPGSpacing.verticalSM,
        InvoiceCard(invoice: invoice2, onTap: () {}, isSelected: true),
      ],
    );
  }

  Widget _buildClassroomCards() {
    final classroom1 = Classroom(
      id: 'C1',
      name: 'Advanced Group',
      coachId: 'c1',
      createdDate: DateTime.now(),
      coach: Coach(idCoach: 'c1', idProfile: 'p3', name: 'Alex Johnson'),
      studentCount: 12,
    );
    final classroom2 = Classroom(
      id: 'C2',
      name: 'Beginner Squad',
      coachId: 'c2',
      createdDate: DateTime.now(),
      coach: Coach(idCoach: 'c2', idProfile: 'p4', name: 'Sarah Williams'),
      studentCount: 8,
    );
    return Column(
      children: [
        ClassroomCard(classroom: classroom1, onTap: () {}),
        KRPGSpacing.verticalSM,
        ClassroomCard(classroom: classroom2, onTap: () {}, isSelected: true),
      ],
    );
  }

  Widget _buildLocationCards() {
    final location1 = Location(
      id: 'L1',
      name: 'Main Swimming Pool',
      address: 'Jl. Gatot Subroto No. 123, Jakarta Selatan',
      latitude: -6.2088,
      longitude: 106.8456,
      description: 'Olympic-size swimming pool with 8 lanes, perfect for training and competitions.',
    );
    final location2 = Location(
      id: 'L2',
      name: 'City Aquatic Center',
      address: 'Jl. Sudirman No. 456, Jakarta Pusat',
      latitude: -6.1754,
      longitude: 106.8272,
      description: 'Modern aquatic center with multiple pools and facilities.',
    );
    final location3 = Location(
      id: 'L3',
      name: 'Training Ground',
      address: 'Jl. Kemang Raya No. 789, Jakarta Selatan',
      latitude: -6.2615,
      longitude: 106.7800,
      description: 'Outdoor training facility with dryland equipment.',
    );
    final location4 = Location(
      id: 'L4',
      name: 'Beach Training Location',
      address: 'Pantai Ancol, Jakarta Utara',
      latitude: -6.1223,
      longitude: 106.8478,
      description: 'Open water swimming training location.',
    );
    return Column(
      children: [
        // Voyager style (default - colorful, modern)
        Text('Voyager Style (Default - Colorful)', style: KRPGTextStyles.bodyMediumSecondary),
        KRPGSpacing.verticalXS,
        LocationCard(location: location1, mapStyle: 'voyager', onTap: () {}),
        KRPGSpacing.verticalSM,
        
        // Light style (minimal)
        Text('Light Style (Minimal)', style: KRPGTextStyles.bodyMediumSecondary),
        KRPGSpacing.verticalXS,
        LocationCard(location: location2, mapStyle: 'light', onTap: () {}),
        KRPGSpacing.verticalSM,
        
        // Dark style
        Text('Dark Style', style: KRPGTextStyles.bodyMediumSecondary),
        KRPGSpacing.verticalXS,
        LocationCard(location: location3, mapStyle: 'dark', onTap: () {}),
        KRPGSpacing.verticalSM,
        
        // OpenTopoMap (colorful topographic)
        Text('Topographic Style (Colorful)', style: KRPGTextStyles.bodyMediumSecondary),
        KRPGSpacing.verticalXS,
        LocationCard(location: location4, mapStyle: 'topo', onTap: () {}),
      ],
    );
  }
} 