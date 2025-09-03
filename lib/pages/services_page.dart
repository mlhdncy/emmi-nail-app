import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import './service_detail_page.dart';
import '../models/service_model.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final List<Service> services = languageProvider.getServices();

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getTranslation('services')),
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiBlack,
        elevation: 1,
      ),
      backgroundColor: AppColors.emmiWhite,
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServiceDetailPage(service: service),
                ));
              },
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: AppColors.emmiRed,
                foregroundColor: AppColors.emmiWhite,
                child: Icon(service.icon, size: 24),
              ),
              title: Text(
                service.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Silka',
                ),
              ),
              subtitle: Text(
                service.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Silka',
                ),
              ),
              trailing: Text(
                '${service.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.emmiRed,
                  fontFamily: 'Silka',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
