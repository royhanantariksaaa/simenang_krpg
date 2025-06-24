import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/classroom_controller.dart';
import '../../../models/classroom_model.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';

class ClassroomDetailScreen extends StatefulWidget {
  final Classroom classroom;

  const ClassroomDetailScreen({
    Key? key,
    required this.classroom,
  }) : super(key: key);

  @override
  State<ClassroomDetailScreen> createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Classroom? _classroom;
  List<Map<String, dynamic>> _students = [];
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadClassroomData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadClassroomData() async {
    final controller = context.read<ClassroomController>();
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Load classroom details
      final classroom = await controller.getClassroomDetails(widget.classroom.id);
      if (classroom != null) {
        _classroom = classroom;
      }

      // Load classroom students
      final students = await controller.getClassroomStudents(widget.classroom.id);
      if (students != null) {
        _students = students;
      }

      // Load classroom stats
      final stats = await controller.getClassroomStats();
      if (stats != null) {
        _stats = stats;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading classroom data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classroom.name ?? 'Unknown Classroom'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit classroom screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Section
                _buildHeaderSection(),
                
                // Tab Bar
                Container(
                  color: KRPGTheme.primaryColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Students'),
                      Tab(text: 'Statistics'),
                    ],
                  ),
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildStudentsTab(),
                      _buildStatisticsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderSection() {
    if (_classroom == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Column(
        children: [
          // Classroom Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.school,
              size: 40,
              color: Colors.white,
            ),
          ),
          KRPGSpacing.verticalSM,
          
          // Classroom Name
          Text(
            _classroom!.name ?? 'Unknown Classroom',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Basic Info
          KRPGSpacing.verticalMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Students', '${_students.length}'),
              _buildInfoItem('Teacher', _classroom!.coach?.name ?? 'Unknown'),
              _buildInfoItem('Status', 'Active'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    if (_classroom == null) {
      return const Center(child: Text('No classroom data available'));
    }

    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Classroom Information
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Classroom Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Classroom Name', _classroom!.name ?? 'Unknown'),
                _buildInfoRow('Teacher', _classroom!.coach?.name ?? 'Unknown'),
                _buildInfoRow('Created Date', _classroom!.createdDate.toString().split(' ')[0]),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Teacher Information
          if (_classroom!.coach != null) ...[
            KRPGCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Teacher Information',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Name', _classroom!.coach!.name ?? 'Unknown'),
                  _buildInfoRow('Email', _classroom!.coach!.email ?? 'Unknown'),
                  _buildInfoRow('Phone', _classroom!.coach!.phone ?? 'Unknown'),
                ],
              ),
            ),
            KRPGSpacing.verticalMD,
          ],
          
          // Quick Stats
          if (_stats != null) ...[
            KRPGCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Statistics',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Total Students', '${_students.length}'),
                  _buildInfoRow('Active Students', '${_students.where((s) => s['status'] == 'active').length}'),
                  _buildInfoRow('Average Age', '${_calculateAverageAge()}'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return ListView.builder(
      padding: KRPGSpacing.paddingMD,
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return KRPGCard(
          margin: const EdgeInsets.only(bottom: 8),
          onTap: () {
            // TODO: Navigate to student detail screen
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: student['profilePicture'] != null
                  ? NetworkImage(student['profilePicture'])
                  : null,
              child: student['profilePicture'] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(student['name'] ?? 'Unknown Student'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${_calculateAge(student['birthDate'])} years'),
                Text('Gender: ${student['gender'] ?? 'Unknown'}'),
                Text('Status: ${student['status'] ?? 'Unknown'}'),
              ],
            ),
            trailing: KRPGBadge(
              text: student['status'] ?? 'Unknown',
              backgroundColor: _getStudentStatusColor(student['status']),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    if (_stats == null) {
      return const Center(child: Text('No statistics available'));
    }

    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        children: [
          // Student Statistics
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Statistics',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Total Students', '${_students.length}'),
                _buildStatRow('Active Students', '${_students.where((s) => s['status'] == 'active').length}'),
                _buildStatRow('Inactive Students', '${_students.where((s) => s['status'] == 'inactive').length}'),
                _buildStatRow('Male Students', '${_students.where((s) => s['gender'] == 'male').length}'),
                _buildStatRow('Female Students', '${_students.where((s) => s['gender'] == 'female').length}'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Age Distribution
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Age Distribution',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Average Age', '${_calculateAverageAge()}'),
                _buildStatRow('Youngest', '${_calculateYoungestAge()}'),
                _buildStatRow('Oldest', '${_calculateOldestAge()}'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Performance Statistics
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Statistics',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Average Attendance', '${_stats!['averageAttendance'] ?? 0}%'),
                _buildStatRow('Total Trainings', '${_stats!['totalTrainings'] ?? 0}'),
                _buildStatRow('Total Competitions', '${_stats!['totalCompetitions'] ?? 0}'),
              ],
            ),
          ),
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
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: KRPGTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(String? birthDate) {
    if (birthDate == null) return 0;
    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      return now.year - birth.year - (now.month < birth.month || (now.month == birth.month && now.day < birth.day) ? 1 : 0);
    } catch (e) {
      return 0;
    }
  }

  double _calculateAverageAge() {
    if (_students.isEmpty) return 0;
    final ages = _students.map((s) => _calculateAge(s['birthDate'])).where((age) => age > 0);
    if (ages.isEmpty) return 0;
    return ages.reduce((a, b) => a + b) / ages.length;
  }

  int _calculateYoungestAge() {
    if (_students.isEmpty) return 0;
    final ages = _students.map((s) => _calculateAge(s['birthDate'])).where((age) => age > 0);
    if (ages.isEmpty) return 0;
    return ages.reduce((a, b) => a < b ? a : b);
  }

  int _calculateOldestAge() {
    if (_students.isEmpty) return 0;
    final ages = _students.map((s) => _calculateAge(s['birthDate'])).where((age) => age > 0);
    if (ages.isEmpty) return 0;
    return ages.reduce((a, b) => a > b ? a : b);
  }

  Color _getStudentStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
} 