import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/emmi_logo.dart';
import '../widgets/angled_lines_painter.dart';
import '../services/auth_service.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        if (mounted) {
          Navigator.of(context).pop(); // Ana sayfaya geri dön
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Giriş başarısız. Email ve şifrenizi kontrol edin.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.emmiRed,
      body: Stack(
        children: [
          // Arkaplan deseni
          Positioned.fill(
            child: CustomPaint(
              painter: AngledLinesPainter(
                lineColor: AppColors.emmiWhite,
                strokeWidth: 1.0,
                spacing: 40.0,
              ),
            ),
          ),

          // 8.5° açıyla döndürülmüş beyaz dikdörtgen
          Positioned(
            top: 120,
            left: -50,
            right: -50,
            child: Transform.rotate(
              angle: 8.5 * (3.14159 / 180),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  color: AppColors.emmiWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // Ana içerik
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // Logo
                  const EmmiLogo(
                    fontSize: 42,
                    color: AppColors.emmiWhite,
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Login Form
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.emmiWhite.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emmiBlack.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            languageProvider.getTranslation('login'),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: AppColors.emmiBlack,
                              fontFamily: 'Silka',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.emmiRed),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.emmiGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email gerekli';
                              }
                              if (!value.contains('@')) {
                                return 'Geçerli bir email girin';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: languageProvider.getTranslation('password'),
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.emmiRed),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  color: AppColors.emmiRed,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.emmiGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Şifre gerekli';
                              }
                              if (value.length < 6) {
                                return 'Şifre en az 6 karakter olmalı';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Login Button
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.emmiRed,
                                foregroundColor: AppColors.emmiWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: AppColors.emmiWhite)
                                  : Text(
                                      languageProvider.getTranslation('login'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Silka',
                                      ),
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                languageProvider.getTranslation('no_account'),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Silka',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const RegistrationPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  languageProvider.getTranslation('register'),
                                  style: const TextStyle(
                                    color: AppColors.emmiRed,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Silka',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.emmiWhite,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}