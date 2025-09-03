import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/appointment_provider.dart';
import '../providers/user_provider.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';
import './login_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  String? _selectedBranch;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedArtist;
  String? _selectedTechnique;

  final List<String> _branches = ['Berlin Mitte', 'Hamburg Altona', 'München Schwabing'];
  final List<String> _artists = ['Jessica', 'Laura', 'Maria'];
  final List<String> _techniques = ['Manikür', 'Pedikür', 'Nagelmodellage', 'Wimpernlifting'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Kullanıcı giriş yapmış ise randevuları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isLoggedIn) {
        final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
        appointmentProvider.loadUserAppointments();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
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
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      _showLoginDialog();
      return;
    }

    if (_formKey.currentState!.validate()) {
      final newAppointment = Appointment(
        serviceName: _selectedTechnique!,
        artist: _selectedArtist!,
        date: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
        branch: _selectedBranch!,
        userId: userProvider.currentUser!.uid,
        createdAt: DateTime.now(),
      );
      
      await _showConfirmationDialog(context, newAppointment);
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giriş Gerekli'),
        content: const Text('Randevu almak için giriş yapmanız gerekiyor.'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emmiRed,
              foregroundColor: AppColors.emmiWhite,
            ),
            child: const Text('Giriş Yap'),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, Appointment appointment) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(languageProvider.getTranslation('confirm_appointment')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${languageProvider.getTranslation('select_technique')}: ${appointment.serviceName}'),
              Text('${languageProvider.getTranslation('select_branch')}: ${appointment.branch}'),
              Text('${languageProvider.getTranslation('select_date')}: ${appointment.date.toLocal().toString().split(' ')[0]}'),
              Text('${languageProvider.getTranslation('select_time')}: ${appointment.date.toLocal().toString().split(' ')[1].substring(0, 5)}'),
              Text('${languageProvider.getTranslation('select_artist')}: ${appointment.artist}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(languageProvider.getTranslation('previous')), // Cancel
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emmiRed,
                foregroundColor: AppColors.emmiWhite,
              ),
              child: Text(languageProvider.getTranslation('confirm_appointment')),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog first
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(color: AppColors.emmiRed),
                  ),
                );
                
                final success = await appointmentProvider.addAppointment(appointment);
                
                // Close loading dialog
                if (mounted) Navigator.pop(context);
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(languageProvider.getTranslation('appointment_request_received')),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  
                  // Reset form
                  setState(() {
                    _selectedBranch = null;
                    _selectedDate = null;
                    _selectedTime = null;
                    _selectedArtist = null;
                    _selectedTechnique = null;
                  });
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Randevu kaydedilemedi. Lütfen tekrar deneyin.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getTranslation('book_appointment_title')),
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiBlack,
        elevation: 1,
      ),
      backgroundColor: AppColors.emmiWhite,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [SliverToBoxAdapter(child: _buildForm(languageProvider))];
        },
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.emmiRed,
              unselectedLabelColor: AppColors.emmiGrey,
              tabs: [
                Tab(text: languageProvider.getTranslation('pending')),
                Tab(text: languageProvider.getTranslation('approved')),
                Tab(text: languageProvider.getTranslation('rejected')),
              ],
            ),
            Expanded(
              child: Consumer<AppointmentProvider>(
                builder: (context, provider, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAppointmentList(provider.pendingAppointments, languageProvider),
                      _buildAppointmentList(provider.approvedAppointments, languageProvider),
                      _buildAppointmentList(provider.rejectedAppointments, languageProvider),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDropdown(
              label: languageProvider.getTranslation('select_branch'),
              value: _selectedBranch,
              items: _branches,
              onChanged: (value) => setState(() => _selectedBranch = value),
              validator: (value) => value == null ? languageProvider.getTranslation('please_select') : null,
            ),
            const SizedBox(height: 20),
            _buildDateTimePicker(
              label: languageProvider.getTranslation('select_date'),
              value: _selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : languageProvider.getTranslation('no_date_selected'),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            _buildDateTimePicker(
              label: languageProvider.getTranslation('select_time'),
              value: _selectedTime != null ? _selectedTime!.format(context) : languageProvider.getTranslation('no_time_selected'),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              label: languageProvider.getTranslation('select_artist'),
              value: _selectedArtist,
              items: _artists,
              onChanged: (value) => setState(() => _selectedArtist = value),
              validator: (value) => value == null ? languageProvider.getTranslation('please_select') : null,
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              label: languageProvider.getTranslation('select_technique'),
              value: _selectedTechnique,
              items: _techniques,
              onChanged: (value) => setState(() => _selectedTechnique = value),
              validator: (value) => value == null ? languageProvider.getTranslation('please_select') : null,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.emmiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  languageProvider.getTranslation('book_appointment'),
                  style: const TextStyle(fontSize: 18, fontFamily: 'Silka', fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<Appointment> appointments, LanguageProvider languageProvider) {
    if (appointments.isEmpty) {
      return Center(child: Text(languageProvider.getTranslation('no_appointments_to_show')));
    }
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return ListTile(
          leading: Icon(_getStatusIcon(appointment.status), color: _getStatusColor(appointment.status)),
          title: Text(appointment.serviceName),
          subtitle: Text('${appointment.date.day}/${appointment.date.month}/${appointment.date.year} - ${appointment.artist}'),
          trailing: Text(appointment.branch, style: TextStyle(color: AppColors.textSecondary)),
        );
      },
    );
  }

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
        return Icons.check_circle;
      case AppointmentStatus.rejected:
        return Icons.cancel;
      case AppointmentStatus.pending:
      default:
        return Icons.hourglass_top;
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.approved:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.red;
      case AppointmentStatus.pending:
      default:
        return Colors.orange;
    }
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged, required FormFieldValidator<String>? validator}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.emmiBeige.withOpacity(0.5),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDateTimePicker({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.emmiBeige.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(value, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.calendar_today, color: AppColors.emmiRed),
          ],
        ),
      ),
    );
  }
}
