import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/appointment_provider.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';

class PastAppointmentsPage extends StatelessWidget {
  const PastAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final pastAppointments = appointmentProvider.approvedAppointments;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getTranslation('past_appointments')),
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiBlack,
        elevation: 1,
      ),
      backgroundColor: AppColors.emmiWhite,
      body: pastAppointments.isEmpty
          ? Center(child: Text(languageProvider.getTranslation('no_approved_appointments')))
          : ListView.builder(
              itemCount: pastAppointments.length,
              itemBuilder: (context, index) {
                final appointment = pastAppointments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      foregroundColor: AppColors.emmiWhite,
                      child: Icon(Icons.check_circle_outline, size: 24),
                    ),
                    title: Text(
                      appointment.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Silka'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${appointment.date.day}/${appointment.date.month}/${appointment.date.year}'),
                        const SizedBox(height: 2),
                        Text('${languageProvider.getTranslation('select_artist')}: ${appointment.artist}'),
                        const SizedBox(height: 2),
                        Text('${languageProvider.getTranslation('select_branch')}: ${appointment.branch}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
