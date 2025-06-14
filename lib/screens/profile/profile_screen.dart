// lib/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:unitime/utils/app_colors.dart';
import 'package:unitime/screens/auth/login/login_screen.dart';
import 'package:unitime/screens/profile/informasi_pribadi_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // --- [BAGIAN INI YANG DIMODIFIKASI] ---
  void _signOut() {
    // Navigasi ke LoginScreen dan hapus semua rute sebelumnya
    // Ini mencegah pengguna kembali ke halaman profil setelah sign out
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method Anda tetap sama persis)
    // ... (salin-tempel dari kode Anda)
    // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profil Saya'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            // const SizedBox(height: 32),
            // _buildSectionTitle('Akses Cepat'),
            // const SizedBox(height: 12),
            // FadeTransition(
            //   opacity: _fadeAnimation,
            //   child: SlideTransition(
            //     position: _slideAnimation,
            //     child: Column(
            //       children: [
            //         _buildAccessCard(
            //           icon: Icons.calendar_today_outlined,
            //           title: 'Jadwal Matakuliah',
            //           subtitle: 'Lihat jadwal kuliah mingguan Anda',
            //           color: Colors.blue,
            //           onTap: () {},
            //         ),
            //         const SizedBox(height: 12),
            //         _buildAccessCard(
            //           icon: Icons.assignment_outlined,
            //           title: 'Tugas Kuliah',
            //           subtitle: 'Cek tugas yang akan datang',
            //           color: Colors.orange,
            //           onTap: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 32),
            _buildSectionTitle('Pengaturan & Akun'),
            const SizedBox(height: 12),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildSettingsSection(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );

    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  }

  // ... (semua widget builder lainnya sama persis)
  // ... (salin-tempel dari kode Anda)
  // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 37,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Altaf Fattah Amanullah',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Teknik Informatika',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.black.withOpacity(0.1), thickness: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Universitas Budi Luhur',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.background,
      elevation: 5,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // --- [PERUBAHAN DI BAGIAN INI] ---
  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            Icons.person_outline,
            'Informasi Pribadi',
            () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => const InformasiPribadiScreen()));
            },
          ),
          _buildDivider(),
          // Ganti callback onTap di sini untuk memanggil fungsi _signOut
          _buildSettingsItem(
            Icons.logout,
            'Sign Out',
            _signOut, // <-- DIUBAH DARI () {} MENJADI _signOut
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : Colors.black87;
    final iconColor = isDestructive ? Colors.red : Colors.black54;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDestructive ? Colors.red.withOpacity(0.7) : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }
}
