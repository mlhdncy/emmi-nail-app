import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'widgets/emmi_logo.dart';
import 'widgets/angled_lines_painter.dart';
import 'firebase_options_secure.dart';
import 'providers/language_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/user_provider.dart';
import 'providers/services_provider.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/booking_page.dart';
import 'pages/services_page.dart';
import 'pages/profile_page.dart';
import 'widgets/emmi_button.dart';
import 'widgets/emmi_sale_tag.dart';

// Web için HTML import
import 'dart:html' as html show window;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final userProvider = UserProvider();
            userProvider.initUserListener(); // Auth state listener'ı başlat
            return userProvider;
          },
        ),
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
        ChangeNotifierProvider(create: (context) => ServicesProvider()),
      ],
      child: const EmmiNailApp(),
    ),
  );
}

class EmmiNailApp extends StatelessWidget {
  const EmmiNailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emmi Nail',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ServicesPage(),
    const BookingPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.emmiWhite,
        selectedItemColor: AppColors.emmiRed,
        unselectedItemColor: AppColors.emmiGrey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        elevation: 8,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            activeIcon: Icon(Icons.home, size: 24, color: AppColors.emmiRed),
            label: languageProvider.getTranslation('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services, size: 24),
            activeIcon: Icon(
              Icons.design_services,
              size: 24,
              color: AppColors.emmiRed,
            ),
            label: languageProvider.getTranslation('services'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 24),
            activeIcon: Icon(
              Icons.calendar_month,
              size: 24,
              color: AppColors.emmiRed,
            ),
            label: languageProvider.getTranslation('appointments'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            activeIcon: Icon(Icons.person, size: 24, color: AppColors.emmiRed),
            label: languageProvider.getTranslation('profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    try {
      if (kIsWeb) {
        // Web için doğrudan HTML kullan
        html.window.open(url, '_blank');
      } else {
        // Mobile için url_launcher kullan
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'URL açılamadı';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('URL açılamadı: $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: AppColors.emmiRed, // Kırmızı arkaplan
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
              controller: _scrollController,
              child: Column(
                children: [
                  // Üst bar - Dil ayarı, Logo ve butonlar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: EmmiLogo(
                              fontSize: 48,
                              color: AppColors.emmiWhite,
                            ),
                          ),
                        ),
                        // Kayıt ve Giriş butonları - Sağ üst
                        Column(
                          children: [
                            SizedBox(
                              width: 100,
                              child: EmmiButton(
                                text: languageProvider.getTranslation(
                                  'register',
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationPage(),
                                    ),
                                  );
                                },
                                isPrimary: false,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 100,
                              child: EmmiButton(
                                text: languageProvider.getTranslation('login'),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                isPrimary: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Slider alanı
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: PageView(
                      children: [
                        _buildSliderCard(
                          languageProvider.getTranslation(
                            'nail_art_collection',
                          ),
                          languageProvider.getTranslation(
                            'nail_art_collection_desc',
                          ),
                          discount: languageProvider.getTranslation('new_tag'),
                          imagePath: 'assets/images/nail_art.jpg',
                        ),
                        _buildSliderCard(
                          languageProvider.getTranslation(
                            'nail_art_collection',
                          ),
                          languageProvider.getTranslation('creative_designs'),
                          discount: '-30%',
                          imagePath: 'assets/images/promo1.jpg',
                        ),
                        _buildSliderCard(
                          languageProvider.getTranslation(
                            'nail_art_collection',
                          ),
                          languageProvider.getTranslation(
                            'professional_quality',
                          ),
                          imagePath: 'assets/images/nail_art.jpg',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Ana butonlar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 140,
                                child: _buildMainButton(
                                  context,
                                  languageProvider.getTranslation('my_profile'),
                                  Icons.person_outline,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfilePage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 140,
                                child: _buildMainButton(
                                  context,
                                  languageProvider.getTranslation(
                                    'book_appointment',
                                  ),
                                  Icons.calendar_today_outlined,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BookingPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 140,
                                child: _buildMainButton(
                                  context,
                                  languageProvider.getTranslation(
                                    'buy_product',
                                  ),
                                  Icons.shopping_bag_outlined,
                                  onTap: () =>
                                      _launchURL('https://emmi-nail.de'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 140,
                                child: _buildMainButton(
                                  context,
                                  languageProvider.getTranslation('services'),
                                  Icons.design_services_outlined,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ServicesPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard(
    String title,
    String subtitle, {
    String? discount,
    String? imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.emmiBlack.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (imagePath != null)
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.emmiBeige,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: AppColors.emmiGrey,
                    ),
                  );
                },
              ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (discount != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emmiRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        discount,
                        style: TextStyle(
                          color: AppColors.emmiWhite,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Silka',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emmiWhite,
                      fontFamily: 'Silka',
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.emmiWhite.withOpacity(0.9),
                      fontFamily: 'Silka',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      color: AppColors.emmiWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.emmiGrey.withOpacity(0.5), width: 1),
      ),
      shadowColor: AppColors.emmiBlack.withOpacity(0.1),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.emmiRed),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontFamily: 'Silka',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
