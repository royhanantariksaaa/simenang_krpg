import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/forms/krpg_form_field.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../config/app_config.dart';
import '../../../components/ui/dummy_data_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'coach'; // Default role

  @override
  void initState() {
    super.initState();
    // Auto-populate default coach data in UEQ-S testing mode
    if (AppConfig.isDummyDataForUEQSTest) {
      _usernameController.text = 'coach@krpg.com';
      _passwordController.text = 'coach123';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authController = context.read<AuthController>();
    final success = await authController.login(
      _usernameController.text.trim(),
      _passwordController.text,
      role: _selectedRole,
    );

    if (!success && mounted) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.error ?? 'Login failed'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // UEQ-S Testing Banner
          const DummyDataBanner(),
          
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(KRPGTheme.spacingLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              // Logo and title
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(KRPGTheme.spacingMd),
                      decoration: BoxDecoration(
                        color: KRPGTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.pool,
                        size: 64,
                        color: KRPGTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    Text(
                      'SiMenang KRPG',
                      style: KRPGTextStyles.heading2.copyWith(
                        color: KRPGTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: KRPGTheme.spacingSm),
                    Text(
                      'Petrokimia Gresik Swimming Club',
                      style: KRPGTextStyles.bodyLarge.copyWith(
                        color: KRPGTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: KRPGTheme.spacingXl),
              
              // Login form
              KRPGCard(
                padding: const EdgeInsets.all(KRPGTheme.spacingLg),
                child: Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: KRPGTextStyles.heading4,
                          ),
                          const SizedBox(height: KRPGTheme.spacingLg),
                          
                          // Username/Email field
                          KRPGFormField(
                            key: const Key('email_field'),
                            controller: _usernameController,
                            label: 'Username or Email',
                            prefixIcon: Icons.person,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username or email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: KRPGTheme.spacingMd),
                          
                          // Password field
                          KRPGFormField(
                            key: const Key('password_field'),
                            controller: _passwordController,
                            label: 'Password',
                            prefixIcon: Icons.lock,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: KRPGTheme.spacingMd),
                          
                          // Role selector (only in UEQ-S testing mode)
                          if (AppConfig.isDummyDataForUEQSTest) ...[
                            Text(
                              'Login sebagai:',
                              style: KRPGTextStyles.bodyMedium.copyWith(
                                fontWeight: KRPGTheme.fontWeightMedium,
                                color: KRPGTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: KRPGTheme.spacingSm),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
                                border: Border.all(color: KRPGTheme.borderColor),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      value: 'coach',
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value!;
                                          // Auto-populate dummy data for coach
                                          _usernameController.text = 'coach@krpg.com';
                                          _passwordController.text = 'coach123';
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.sports,
                                            color: KRPGTheme.primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: KRPGTheme.spacingSm),
                                          Text(
                                            'Pelatih',
                                            style: KRPGTextStyles.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      activeColor: KRPGTheme.primaryColor,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: KRPGTheme.spacingSm),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      value: 'athlete',
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value!;
                                          // Auto-populate dummy data for athlete
                                          _usernameController.text = 'athlete@krpg.com';
                                          _passwordController.text = 'athlete123';
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.pool,
                                            color: KRPGTheme.primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: KRPGTheme.spacingSm),
                                          Text(
                                            'Atlet',
                                            style: KRPGTextStyles.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      activeColor: KRPGTheme.primaryColor,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: KRPGTheme.spacingSm),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      value: 'admin',
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value!;
                                          // Auto-populate dummy data for ketua
                                          _usernameController.text = 'ketua@krpg.com';
                                          _passwordController.text = 'ketua123';
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.verified_user,
                                            color: KRPGTheme.primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: KRPGTheme.spacingSm),
                                          Text(
                                            'Ketua',
                                            style: KRPGTextStyles.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      activeColor: KRPGTheme.primaryColor,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: KRPGTheme.spacingSm),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: KRPGTheme.spacingMd),
                          ],
                          
                          // Error message
                          if (authController.error != null)
                            Container(
                              padding: const EdgeInsets.all(KRPGTheme.spacingSm),
                              margin: const EdgeInsets.only(bottom: KRPGTheme.spacingMd),
                              decoration: BoxDecoration(
                                color: KRPGTheme.dangerColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                                border: Border.all(
                                  color: KRPGTheme.dangerColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: KRPGTheme.dangerColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: KRPGTheme.spacingSm),
                                  Expanded(
                                    child: Text(
                                      authController.error!,
                                      style: KRPGTextStyles.bodyMedium.copyWith(
                                        color: KRPGTheme.dangerColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          // Login button
                          KRPGButton(
                            key: const Key('login_button'),
                            text: 'Login',
                            isLoading: authController.isLoading,
                            onPressed: _handleLogin,
                            isFullWidth: true,
                            size: KRPGButtonSize.large,
                          ),
                          
                          const SizedBox(height: KRPGTheme.spacingMd),
                          
                          // Forgot password
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Forgot password functionality coming soon'),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: KRPGTextStyles.bodyMedium.copyWith(
                                  color: KRPGTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // UEQ-S Testing Instructions
              if (AppConfig.isDummyDataForUEQSTest)
                Container(
                  margin: const EdgeInsets.only(top: KRPGTheme.spacingLg),
                  padding: const EdgeInsets.all(KRPGTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: KRPGTheme.backgroundAccent,
                    borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
                    border: Border.all(
                      color: KRPGTheme.borderColorGreen,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: KRPGTheme.infoColor,
                            size: 20,
                          ),
                          const SizedBox(width: KRPGTheme.spacingSm),
                          Text(
                            'Mode Testing UEQ-S',
                            style: KRPGTextStyles.bodyMedium.copyWith(
                              fontWeight: KRPGTheme.fontWeightSemiBold,
                              color: KRPGTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: KRPGTheme.spacingSm),
                      Text(
                        'Klik pada peran (Pelatih/Atlet/Ketua) untuk mengisi otomatis username dan password. Sistem akan menggunakan data dummy untuk pengujian.',
                        style: KRPGTextStyles.bodySmall.copyWith(
                          color: KRPGTheme.textMedium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 