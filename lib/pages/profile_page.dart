import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import './past_appointments_page.dart';
import './nail_album_page.dart';
import './login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Kullanıcı bilgilerini yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isLoggedIn) {
        _loadUserData(userProvider);
      }
    });
  }

  void _loadUserData(UserProvider userProvider) {
    final user = userProvider.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      _cityController.text = user.city ?? '';
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final success = await userProvider.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil başarıyla güncellendi'),
          backgroundColor: AppColors.success,
        ),
      );
      setState(() {
        _isEditing = false;
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil güncellenirken hata oluştu'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.signOut();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Çıkış yapıldı'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giriş Gerekli'),
        content: const Text(
          'Bu özelliği kullanmak için giriş yapmanız gerekiyor.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Giriş Yap'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getTranslation('profile')),
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiBlack,
        elevation: 1,
        actions: [
          if (userProvider.isLoggedIn) ...[
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          ],
        ],
      ),
      backgroundColor: AppColors.emmiWhite,
      body: userProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.emmiRed),
            )
          : !userProvider.isLoggedIn
          ? _buildLoginPrompt(languageProvider)
          : _buildProfileContent(languageProvider, userProvider),
    );
  }

  Widget _buildLoginPrompt(LanguageProvider languageProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 80,
              color: AppColors.emmiGrey,
            ),
            const SizedBox(height: 24),
            Text(
              'Profil sayfasına erişmek için giriş yapın',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.emmiBlack,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emmiRed,
                foregroundColor: AppColors.emmiWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    LanguageProvider languageProvider,
    UserProvider userProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(userProvider),
          const SizedBox(height: 32),
          _buildSectionTitle(
            context,
            languageProvider.getTranslation('personal_info'),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: languageProvider.getTranslation('name'),
            controller: _nameController,
            isEnabled: _isEditing,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Email',
            controller: TextEditingController(
              text: userProvider.currentUser?.email ?? '',
            ),
            isEnabled: false,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: languageProvider.getTranslation('phone'),
            controller: _phoneController,
            isEnabled: _isEditing,
            inputType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Adres',
            controller: _addressController,
            isEnabled: _isEditing,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Şehir',
            controller: _cityController,
            isEnabled: _isEditing,
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(
            context,
            languageProvider.getTranslation('my_appointments'),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            icon: Icons.calendar_today,
            title: languageProvider.getTranslation('past_appointments'),
            subtitle: languageProvider.getTranslation('view_past_appointments'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PastAppointmentsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(
            context,
            languageProvider.getTranslation('my_nail_album'),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            icon: Icons.photo_album,
            title: languageProvider.getTranslation('photo_gallery'),
            subtitle: languageProvider.getTranslation('manage_your_designs'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NailAlbumPage()),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(
            context,
            languageProvider.getTranslation('language_settings'),
          ),
          const SizedBox(height: 16),
          _buildLanguageSelector(languageProvider),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProvider userProvider) {
    final user = userProvider.currentUser;
    final initials = user != null
        ? user.name
              .split(' ')
              .map((name) => name.isNotEmpty ? name[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : 'U';

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.emmiRed,
            backgroundImage: user?.profileImageUrl != null
                ? NetworkImage(user!.profileImageUrl!)
                : null,
            child: user?.profileImageUrl == null
                ? Text(
                    initials,
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? 'Kullanıcı',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Silka',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isEnabled = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !isEnabled,
        fillColor: AppColors.emmiBeige.withOpacity(0.4),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Silka',
        color: AppColors.emmiRed,
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: AppColors.emmiRed, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Silka',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Silka'),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildLanguageOption(languageProvider, 'TR', '🇹🇷', 'Türkçe'),
        _buildLanguageOption(languageProvider, 'DE', '🇩🇪', 'Deutsch'),
        _buildLanguageOption(languageProvider, 'EN', '🇬🇧', 'English'),
      ],
    );
  }

  Widget _buildLanguageOption(
    LanguageProvider languageProvider,
    String langCode,
    String flag,
    String languageName,
  ) {
    final isSelected = languageProvider.selectedLanguage == langCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          languageProvider.changeLanguage(langCode);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.emmiRed.withOpacity(0.1)
                : AppColors.emmiWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.emmiRed : AppColors.emmiGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  languageName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.emmiRed : AppColors.emmiBlack,
                    fontFamily: 'Silka',
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.emmiRed, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
