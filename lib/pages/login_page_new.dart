import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/emmi_logo.dart';
import '../widgets/angled_lines_painter.dart';
import '../widgets/emmi_button.dart';
import '../services/auth_service.dart';
import 'registration_page.dart';
import 'business_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _customerFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();

  final _customerEmailController = TextEditingController();
  final _customerPasswordController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _businessPasswordController = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscureCustomerPassword = true;
  bool _obscureBusinessPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customerEmailController.dispose();
    _customerPasswordController.dispose();
    _businessEmailController.dispose();
    _businessPasswordController.dispose();
    super.dispose();
  }

  Future<void> _customerLogin() async {
    if (_customerFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await _authService.signInWithEmailAndPassword(
        _customerEmailController.text.trim(),
        _customerPasswordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _businessLogin() async {
    if (_businessFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await _authService.signInWithEmailAndPassword(
        _businessEmailController.text.trim(),
        _businessPasswordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          // İşletme girişi için dashboard'a yönlendir
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BusinessDashboard()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
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
                height: 650,
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
                  const EmmiLogo(fontSize: 42, color: AppColors.emmiWhite),

                  const SizedBox(height: 60),

                  // Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.emmiWhite,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emmiBlack.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.emmiRed,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: AppColors.emmiWhite,
                      unselectedLabelColor: AppColors.emmiRed,
                      tabs: const [
                        Tab(height: 50, text: 'Müşteri Girişi'),
                        Tab(height: 50, text: 'İşletme Girişi'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Tab Views
                  Container(
                    height: 400,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Müşteri Girişi
                        _buildCustomerLoginForm(),
                        // İşletme Girişi
                        _buildBusinessLoginForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerLoginForm() {
    return Form(
      key: _customerFormKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: _customerEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email adresi gerekli';
              }
              if (!value.contains('@')) {
                return 'Geçerli bir email adresi girin';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password
          TextFormField(
            controller: _customerPasswordController,
            obscureText: _obscureCustomerPassword,
            decoration: InputDecoration(
              labelText: 'Şifre',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCustomerPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureCustomerPassword = !_obscureCustomerPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Şifre gerekli';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          // Giriş Butonu
          SizedBox(
            width: double.infinity,
            child: EmmiButton(
              text: _isLoading ? 'Giriş yapılıyor...' : 'Giriş Yap',
              onPressed: _isLoading ? null : _customerLogin,
              isPrimary: true,
            ),
          ),

          const SizedBox(height: 20),

          // Kayıt ol linki
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hesabınız yok mu? '),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                },
                child: const Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    color: AppColors.emmiRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessLoginForm() {
    return Form(
      key: _businessFormKey,
      child: Column(
        children: [
          // İşletme Email
          TextFormField(
            controller: _businessEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'İşletme Email',
              prefixIcon: const Icon(Icons.business),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'İşletme email adresi gerekli';
              }
              if (!value.contains('@')) {
                return 'Geçerli bir email adresi girin';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password
          TextFormField(
            controller: _businessPasswordController,
            obscureText: _obscureBusinessPassword,
            decoration: InputDecoration(
              labelText: 'İşletme Şifresi',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureBusinessPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureBusinessPassword = !_obscureBusinessPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'İşletme şifresi gerekli';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          // İşletme Giriş Butonu
          SizedBox(
            width: double.infinity,
            child: EmmiButton(
              text: _isLoading
                  ? 'Giriş yapılıyor...'
                  : 'İşletme Paneline Giriş',
              onPressed: _isLoading ? null : _businessLogin,
              isPrimary: true,
            ),
          ),

          const SizedBox(height: 20),

          // İşletme kaydı bilgisi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'İşletme hesabı için lütfen yönetici ile iletişime geçin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
