import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:html' as html;
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/emmi_logo.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    'Dashboard',
    'Müşteriler',
    'Randevu Talepleri',
    'Geçmiş Randevular',
    'Mail Gönder',
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard,
    Icons.people,
    Icons.pending_actions,
    Icons.history,
    Icons.email,
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.emmiRed,
              elevation: 0,
              title: const EmmiLogo(fontSize: 24, color: AppColors.emmiWhite),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.emmiWhite),
                  onPressed: () => _logout(context),
                ),
              ],
            )
          : null,
      drawer: !isDesktop ? _buildDrawer() : null,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: AppColors.emmiWhite,
            boxShadow: [
              BoxShadow(
                color: AppColors.emmiBlack.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: _buildSidebar(),
        ),
        // Main content
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return _buildMainContent();
  }

  Widget _buildDrawer() {
    return Drawer(child: _buildSidebar());
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        // Logo ve başlık
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: AppColors.emmiRed),
          child: const Column(
            children: [
              EmmiLogo(fontSize: 24, color: AppColors.emmiWhite),
              SizedBox(height: 8),
              Text(
                'İşletme Paneli',
                style: TextStyle(
                  color: AppColors.emmiWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Menu items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedIndex == index;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.emmiRed.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(
                    _menuIcons[index],
                    color: isSelected
                        ? AppColors.emmiRed
                        : AppColors.textSecondary,
                  ),
                  title: Text(
                    _menuItems[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.emmiRed
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    if (MediaQuery.of(context).size.width <= 800) {
                      Navigator.pop(context);
                    }
                  },
                ),
              );
            },
          ),
        ),

        // Logout butonu
        if (MediaQuery.of(context).size.width > 800)
          Container(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => _logout(context),
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardHome();
      case 1:
        return const CustomersPage();
      case 2:
        return const PendingAppointments();
      case 3:
        return const PastAppointments();
      case 4:
        return const SendMailPage();
      default:
        return const DashboardHome();
    }
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Dashboard Ana Sayfa
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // İstatistik kartları
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  _buildStatCard(
                    'Toplam Müşteri',
                    Icons.people,
                    AppColors.accent,
                    futureValue: _getTotalCustomers(),
                  ),
                  _buildStatCard(
                    'Bekleyen Randevular',
                    Icons.pending_actions,
                    AppColors.warning,
                    futureValue: _getPendingAppointments(),
                  ),
                  _buildStatCard(
                    'Bu Ay Randevular',
                    Icons.calendar_month,
                    AppColors.success,
                    futureValue: _getMonthlyAppointments(),
                  ),
                  _buildStatCard(
                    'Toplam Gelir',
                    Icons.monetization_on,
                    AppColors.emmiRed,
                    futureValue: _getTotalRevenue(),
                    prefix: '₺',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    IconData icon,
    Color color, {
    Future<int>? futureValue,
    String prefix = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emmiWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.emmiBlack.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<int>(
                  future: futureValue ?? Future.value(0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return Text(
                      '$prefix${snapshot.data ?? 0}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _getTotalCustomers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.length;
  }

  Future<int> _getPendingAppointments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getMonthlyAppointments() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getTotalRevenue() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('status', isEqualTo: 'completed')
        .get();

    int total = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['price'] != null) {
        total += (data['price'] as num).toInt();
      }
    }
    return total;
  }
}

// Müşteriler Sayfası
class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  String _formatDateForFile(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Müşteriler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _exportCustomerData(context),
                icon: const Icon(Icons.download),
                label: const Text('Dışa Aktar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emmiRed,
                  foregroundColor: AppColors.emmiWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Henüz müşteri bulunmuyor.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final customer =
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                    return _buildCustomerCard(customer);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emmiWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.emmiBlack.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.emmiRed,
            child: Text(
              (customer['name'] ?? 'A')
                  .toString()
                  .substring(0, 1)
                  .toUpperCase(),
              style: const TextStyle(color: AppColors.emmiWhite),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer['name'] ?? 'İsimsiz',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  customer['email'] ?? '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                if (customer['phone'] != null)
                  Text(
                    customer['phone'],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _launchEmail(customer['email']),
            icon: const Icon(Icons.email, color: AppColors.emmiRed),
          ),
        ],
      ),
    );
  }

  void _exportCustomerData(BuildContext context) async {
    try {
      final customers = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final appointments = await FirebaseFirestore.instance
          .collection('appointments')
          .get();

      List<Map<String, dynamic>> exportData = [];

      for (var customerDoc in customers.docs) {
        final customer = customerDoc.data();
        final customerAppointments = appointments.docs
            .where((apt) => apt.data()['userId'] == customerDoc.id)
            .map((apt) => apt.data())
            .toList();

        exportData.add({
          'customer': customer,
          'appointments': customerAppointments,
        });
      }

      final jsonString = jsonEncode(exportData);
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute(
          'download',
          'customer_data_${_formatDateForFile(DateTime.now())}.json',
        )
        ..click();

      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Müşteri verileri başarıyla dışa aktarıldı!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  void _launchEmail(String? email) async {
    if (email != null) {
      final Uri emailUri = Uri(scheme: 'mailto', path: email);
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    }
  }
}

// Bekleyen Randevular Sayfası
class PendingAppointments extends StatelessWidget {
  const PendingAppointments({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Randevu Talepleri',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('status', isEqualTo: 'pending')
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Bekleyen randevu talebi bulunmuyor.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final appointment = snapshot.data!.docs[index];
                    return _buildAppointmentCard(context, appointment);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    QueryDocumentSnapshot appointment,
  ) {
    final data = appointment.data() as Map<String, dynamic>;
    final date = (data['date'] as Timestamp).toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emmiWhite,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(width: 4, color: AppColors.warning),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emmiBlack.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['customerName'] ?? 'İsimsiz Müşteri',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatDate(date),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Hizmet: ${data['serviceName'] ?? 'Belirtilmemiş'}',
            style: const TextStyle(fontSize: 14),
          ),
          if (data['notes'] != null && data['notes'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Not: ${data['notes']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _updateAppointmentStatus(
                    context,
                    appointment.id,
                    'approved',
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Onayla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.emmiWhite,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _updateAppointmentStatus(
                    context,
                    appointment.id,
                    'rejected',
                  ),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Reddet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.emmiWhite,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateAppointmentStatus(
    BuildContext context,
    String appointmentId,
    String status,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'approved' ? 'Randevu onaylandı!' : 'Randevu reddedildi!',
          ),
          backgroundColor: status == 'approved'
              ? AppColors.success
              : AppColors.error,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }
}

// Geçmiş Randevular Sayfası
class PastAppointments extends StatelessWidget {
  const PastAppointments({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Geçmiş Randevular',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('date', isLessThan: Timestamp.now())
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Geçmiş randevu bulunmuyor.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final appointment = snapshot.data!.docs[index];
                    return _buildPastAppointmentCard(appointment);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastAppointmentCard(QueryDocumentSnapshot appointment) {
    final data = appointment.data() as Map<String, dynamic>;
    final date = (data['date'] as Timestamp).toDate();
    final status = data['status'] ?? 'unknown';

    Color statusColor;
    switch (status) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      case 'approved':
        statusColor = AppColors.accent;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emmiWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(width: 4, color: statusColor)),
        boxShadow: [
          BoxShadow(
            color: AppColors.emmiBlack.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['customerName'] ?? 'İsimsiz Müşteri',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(date),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            'Hizmet: ${data['serviceName'] ?? 'Belirtilmemiş'}',
            style: const TextStyle(fontSize: 14),
          ),
          if (data['price'] != null)
            Text(
              'Ücret: ₺${data['price']}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Tamamlandı';
      case 'cancelled':
        return 'İptal Edildi';
      case 'approved':
        return 'Onaylandı';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Bilinmiyor';
    }
  }
}

// Mail Gönderme Sayfası
class SendMailPage extends StatefulWidget {
  const SendMailPage({super.key});

  @override
  State<SendMailPage> createState() => _SendMailPageState();
}

class _SendMailPageState extends State<SendMailPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sendToAll = true;
  String? _selectedCustomerEmail;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mail Gönder',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alıcı seçimi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.emmiWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emmiBlack.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alıcılar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: _sendToAll,
                              onChanged: (value) {
                                setState(() {
                                  _sendToAll = value!;
                                });
                              },
                            ),
                            const Text('Tüm müşterilere gönder'),
                          ],
                        ),

                        Row(
                          children: [
                            Radio<bool>(
                              value: false,
                              groupValue: _sendToAll,
                              onChanged: (value) {
                                setState(() {
                                  _sendToAll = value!;
                                });
                              },
                            ),
                            const Text('Belirli müşteriye gönder'),
                          ],
                        ),

                        if (!_sendToAll) ...[
                          const SizedBox(height: 8),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              return DropdownButtonFormField<String>(
                                value: _selectedCustomerEmail,
                                decoration: const InputDecoration(
                                  labelText: 'Müşteri Seç',
                                  border: OutlineInputBorder(),
                                ),
                                items: snapshot.data!.docs.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return DropdownMenuItem<String>(
                                    value: data['email'],
                                    child: Text(
                                      '${data['name']} (${data['email']})',
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCustomerEmail = value;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Konu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.emmiWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emmiBlack.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Mail Konusu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mesaj
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.emmiWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emmiBlack.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Mesaj İçeriği',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Gönder butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendMail,
                      icon: const Icon(Icons.send),
                      label: const Text('Mail Gönder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emmiRed,
                        foregroundColor: AppColors.emmiWhite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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

  void _sendMail() async {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen konu ve mesajı doldurun.')),
      );
      return;
    }

    if (!_sendToAll && _selectedCustomerEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir müşteri seçin.')),
      );
      return;
    }

    try {
      List<String> recipients = [];

      if (_sendToAll) {
        final customers = await FirebaseFirestore.instance
            .collection('users')
            .get();
        recipients = customers.docs
            .map((doc) => (doc.data()['email'] as String?))
            .where((email) => email != null)
            .cast<String>()
            .toList();
      } else {
        recipients = [_selectedCustomerEmail!];
      }

      // E-posta istemcisini aç
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: '',
        query:
            'bcc=${recipients.join(',')}&subject=${Uri.encodeComponent(_subjectController.text)}&body=${Uri.encodeComponent(_messageController.text)}',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-posta istemcisi açıldı!')),
        );
      } else {
        throw 'E-posta istemcisi açılamadı';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }
}
