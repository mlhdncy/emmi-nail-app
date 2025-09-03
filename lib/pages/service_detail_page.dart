import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service_model.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import './booking_page.dart';

class ServiceDetailPage extends StatelessWidget {
  final Service service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiBlack,
        elevation: 1,
      ),
      backgroundColor: AppColors.emmiWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.emmiRed.withOpacity(0.1),
                child: Icon(service.icon, size: 50, color: AppColors.emmiRed),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                service.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Silka',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '€${service.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.emmiRed,
                  fontFamily: 'Silka',
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, languageProvider.getTranslation('service_description')),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontFamily: 'Silka',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, languageProvider.getTranslation('available_branches')),
            const SizedBox(height: 8),
            _buildBranchList(context, ['Berlin Mitte', 'Hamburg Altona', 'München Schwabing']),
            const SizedBox(height: 24),
            _buildSectionTitle(context, languageProvider.getTranslation('detailed_info')),
            const SizedBox(height: 8),
            Text(
              languageProvider.getTranslation('detailed_info_text'),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontFamily: 'Silka',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BookingPage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.emmiRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  languageProvider.getTranslation('book_appointment'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Silka',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildBranchList(BuildContext context, List<String> branches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: branches.map((branch) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            const Icon(Icons.store, color: AppColors.emmiRed, size: 20),
            const SizedBox(width: 8),
            Text(
              branch,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Silka',
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
