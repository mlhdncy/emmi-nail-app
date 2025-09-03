import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/emmi_logo.dart';
import '../widgets/angled_lines_painter.dart';
import '../services/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final PageController _pageController = PageController();
  final _authService = AuthService();
  
  // Form keys
  final _personalInfoKey = GlobalKey<FormState>();
  final _contactInfoKey = GlobalKey<FormState>();
  final _accountInfoKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  int _currentStep = 0;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDate;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 yaş
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.emmiRed,
              onPrimary: AppColors.emmiWhite,
              surface: AppColors.emmiWhite,
              onSurface: AppColors.emmiBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _nextStep() {
    bool isValid = false;
    
    switch (_currentStep) {
      case 0:
        isValid = _personalInfoKey.currentState!.validate();
        break;
      case 1:
        isValid = _contactInfoKey.currentState!.validate();
        break;
      case 2:
        isValid = _accountInfoKey.currentState!.validate() && _termsAccepted;
        if (isValid) {
          _register();
          return;
        }
        break;
    }
    
    if (isValid && _currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.registerWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
      '${_nameController.text.trim()} ${_surnameController.text.trim()}',
      _phoneController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst); // Ana sayfaya dön
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kayıt başarılı! Hoş geldiniz.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kayıt başarısız. Lütfen tekrar deneyin.'),
            backgroundColor: AppColors.error,
          ),
        );
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

          // Ana içerik
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const EmmiLogo(
                        fontSize: 32,
                        color: AppColors.emmiWhite,
                      ),
                      const SizedBox(height: 20),
                      
                      // Progress Indicator
                      Row(
                        children: List.generate(3, (index) {
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                right: index < 2 ? 8 : 0,
                                left: index > 0 ? 8 : 0,
                              ),
                              height: 4,
                              decoration: BoxDecoration(
                                color: index <= _currentStep 
                                    ? AppColors.emmiWhite 
                                    : AppColors.emmiWhite.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppColors.emmiWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emmiBlack.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildPersonalInfoStep(languageProvider),
                        _buildContactInfoStep(languageProvider),
                        _buildAccountInfoStep(languageProvider),
                      ],
                    ),
                  ),
                ),

                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.emmiWhite,
                              side: const BorderSide(color: AppColors.emmiWhite),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              languageProvider.getTranslation('previous'),
                              style: const TextStyle(
                                fontFamily: 'Silka',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      
                      if (_currentStep > 0) const SizedBox(width: 16),
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emmiWhite,
                            foregroundColor: AppColors.emmiRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.emmiRed,
                                  ),
                                )
                              : Text(
                                  _currentStep == 2 
                                      ? languageProvider.getTranslation('complete_registration')
                                      : languageProvider.getTranslation('next'),
                                  style: const TextStyle(
                                    fontFamily: 'Silka',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _buildPersonalInfoStep(LanguageProvider languageProvider) {
    return Form(
      key: _personalInfoKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.getTranslation('personal_info'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.emmiBlack,
                fontFamily: 'Silka',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.getTranslation('personal_info_desc'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'Silka',
              ),
            ),
            const SizedBox(height: 30),
            
            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('name'),
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.getTranslation('name_required');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Surname
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('surname'),
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.getTranslation('surname_required');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Birth Date
            TextFormField(
              controller: _birthDateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('birth_date'),
                prefixIcon: const Icon(Icons.calendar_today, color: AppColors.emmiRed),
                suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.getTranslation('birth_date_required');
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoStep(LanguageProvider languageProvider) {
    return Form(
      key: _contactInfoKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.getTranslation('contact_info'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.emmiBlack,
                fontFamily: 'Silka',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.getTranslation('contact_info_desc'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'Silka',
              ),
            ),
            const SizedBox(height: 30),
            
            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('phone'),
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.getTranslation('phone_required');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Address
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('address'),
                prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.getTranslation('address_required');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // City
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('city'),
                prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return languageProvider.getTranslation('city_required');
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoStep(LanguageProvider languageProvider) {
    return Form(
      key: _accountInfoKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.getTranslation('account_info'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.emmiBlack,
                fontFamily: 'Silka',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              languageProvider.getTranslation('account_info_desc'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'Silka',
              ),
            ),
            const SizedBox(height: 30),
            
            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.emmiRed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
            
            // Password
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
            
            const SizedBox(height: 20),
            
            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: languageProvider.getTranslation('confirm_password'),
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.emmiRed),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.emmiRed,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.emmiRed, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre tekrarı gerekli';
                }
                if (value != _passwordController.text) {
                  return 'Şifreler uyuşmuyor';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Terms and Conditions
            CheckboxListTile(
              value: _termsAccepted,
              onChanged: (value) {
                setState(() {
                  _termsAccepted = value ?? false;
                });
              },
              activeColor: AppColors.emmiRed,
              title: Text(
                languageProvider.getTranslation('accept_terms'),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Silka',
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}