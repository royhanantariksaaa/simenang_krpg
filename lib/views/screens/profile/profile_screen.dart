import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/membership_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    // Load membership data for athletes
    final authController = context.read<AuthController>();
    if (authController.currentUser?.role == UserRole.athlete) {
      final membershipController = context.read<MembershipController>();
      membershipController.getMembershipStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(KRPGTheme.spacingMd),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: KRPGTheme.spacingLg),
            _buildProfileDetails(),
            const SizedBox(height: KRPGTheme.spacingLg),
            _buildMembershipSection(),
            const SizedBox(height: KRPGTheme.spacingLg),
            _buildActions(),
            const SizedBox(height: KRPGTheme.spacingLg),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          return const SizedBox.shrink();
        }

        return KRPGCard(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: KRPGTheme.primaryColor,
                backgroundImage: currentUser.profile?.profilePicture != null
                    ? NetworkImage(currentUser.profile!.profilePicture!)
                    : null,
                child: currentUser.profile?.profilePicture == null
                    ? Text(
                        currentUser.profile?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: KRPGTextStyles.heading2.copyWith(
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              Text(
                currentUser.profile?.name ?? 'Unknown User',
                style: KRPGTextStyles.heading4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: KRPGTheme.spacingXs),
              Text(
                currentUser.role.displayName,
                style: KRPGTextStyles.bodyMedium.copyWith(
                  color: KRPGTheme.textMedium,
                ),
              ),
              const SizedBox(height: KRPGTheme.spacingXs),
              Text(
                currentUser.email,
                style: KRPGTextStyles.bodySmall.copyWith(
                  color: KRPGTheme.textMedium,
                ),
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              KRPGButton(
                text: 'Edit Profile',
                onPressed: () {
                  _showEditProfileDialog();
                },
                size: KRPGButtonSize.small,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileDetails() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final currentUser = authController.currentUser;
        if (currentUser?.profile == null) {
          return const SizedBox.shrink();
        }

        final profile = currentUser!.profile!;

        return KRPGCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              _buildDetailRow('Phone', profile.phoneNumber ?? 'Not set'),
              _buildDetailRow('Address', profile.address ?? 'Not set'),
              _buildDetailRow('Birth Date', profile.birthDate?.toString() ?? 'Not set'),
              _buildDetailRow('Gender', profile.gender?.value ?? 'Not set'),
              if (profile.city != null) _buildDetailRow('City', profile.city!),
              if (profile.joinDate != null) _buildDetailRow('Join Date', profile.joinDate!.toString()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KRPGTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: KRPGTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

  Widget _buildMembershipSection() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        // Only show membership section for athletes
        if (authController.currentUser?.role != UserRole.athlete) {
          return const SizedBox.shrink();
        }

        return Consumer<MembershipController>(
          builder: (context, membershipController, child) {
            if (membershipController.isLoading) {
              return KRPGCard(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final membershipStatus = membershipController.membershipStatus;
            if (membershipStatus == null) {
              return const SizedBox.shrink();
            }

            return KRPGCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Membership Status',
                    style: KRPGTextStyles.heading5,
                  ),
                  const SizedBox(height: KRPGTheme.spacingMd),
                  _buildMembershipStatus(membershipStatus),
                  const SizedBox(height: KRPGTheme.spacingMd),
                  KRPGButton(
                    text: 'View Payment History',
                    onPressed: () {
                      _showPaymentHistory();
                    },
                    size: KRPGButtonSize.small,
                    type: KRPGButtonType.outlined,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMembershipStatus(Map<String, dynamic> status) {
    final isActive = status['is_active'] ?? false;
    final membershipType = status['membership_type'] ?? 'Unknown';
    final expiryDate = status['expiry_date'];
    final paymentStatus = status['payment_status'] ?? 'Unknown';

    return Column(
      children: [
        Row(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? KRPGTheme.successColor : KRPGTheme.dangerColor,
              size: 20,
            ),
            const SizedBox(width: KRPGTheme.spacingSm),
            Text(
              isActive ? 'Active' : 'Inactive',
              style: KRPGTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isActive ? KRPGTheme.successColor : KRPGTheme.dangerColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: KRPGTheme.spacingSm),
        _buildDetailRow('Type', membershipType),
        if (expiryDate != null) _buildDetailRow('Expires', expiryDate),
        _buildDetailRow('Payment', paymentStatus),
      ],
    );
  }

  Widget _buildActions() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          return const SizedBox.shrink();
        }

        return KRPGCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              _buildActionTile(
                icon: Icons.change_circle,
                title: 'Change Password',
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              _buildActionTile(
                icon: Icons.upload_file,
                title: 'Upload Profile Picture',
                onTap: () {
                  _showUploadPictureDialog();
                },
              ),
              if (currentUser.role == UserRole.athlete)
                _buildActionTile(
                  icon: Icons.payment,
                  title: 'Upload Payment Evidence',
                  onTap: () {
                    _showUploadPaymentDialog();
                  },
                ),
              _buildActionTile(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {
                  _showHelpDialog();
                },
              ),
              _buildActionTile(
                icon: Icons.info,
                title: 'About App',
                onTap: () {
                  _showAboutDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: KRPGTheme.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: KRPGTextStyles.bodyMedium,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: KRPGTheme.textMedium,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return KRPGButton(
          text: 'Logout',
          onPressed: () {
            _showLogoutConfirmation();
          },
          backgroundColor: KRPGTheme.dangerColor,
          textColor: Colors.white,
        );
      },
    );
  }

  void _showEditProfileDialog() {
    // TODO: Implement edit profile dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile functionality coming soon'),
      ),
    );
  }

  void _showChangePasswordDialog() {
    // TODO: Implement change password dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change password functionality coming soon'),
      ),
    );
  }

  void _showUploadPictureDialog() {
    // TODO: Implement upload picture dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload picture functionality coming soon'),
      ),
    );
  }

  void _showUploadPaymentDialog() {
    // TODO: Implement upload payment dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload payment functionality coming soon'),
      ),
    );
  }

  void _showPaymentHistory() {
    // TODO: Navigate to payment history screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment history functionality coming soon'),
      ),
    );
  }

  void _showSettingsDialog() {
    // TODO: Implement settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings functionality coming soon'),
      ),
    );
  }

  void _showHelpDialog() {
    // TODO: Implement help dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support functionality coming soon'),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SiMenang KRPG',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.pool,
        color: KRPGTheme.primaryColor,
        size: 48,
      ),
      children: [
        const Text(
          'A comprehensive swimming training and competition management app.',
        ),
      ],
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: KRPGTheme.dangerColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    final authController = context.read<AuthController>();
    authController.logout();
  }
} 