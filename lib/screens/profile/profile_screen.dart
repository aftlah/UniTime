
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unitime/models/user_model.dart';
import 'package:unitime/services/user_service.dart';
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

  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserProfile();

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

    _userFuture.whenComplete(() {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  Future<UserModel> _loadUserProfile() async {
    try {
      final localUser = await UserService.getUserLogin();

      if (localUser == null) {
        throw Exception(
            'Sesi pengguna tidak ditemukan. Silakan login kembali.');
      }

      final serverUser = await UserService.getBiodata(localUser.id.toString());
      return serverUser;
    } catch (e) {
      throw Exception(
          'Gagal memuat profil: ${e.toString().replaceAll("Exception:", "")}');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await UserService.logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showSignOutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Sign Out'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profil Saya'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      snapshot.error.toString().replaceAll(
                          "Exception: ", ""), 
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Kembali ke Halaman Login'),
                  )
                ],
              ),
            );
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),
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
          );
        },
      ),
    );
  }


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

  Widget _buildProfileHeader(UserModel user) {
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
              // const CircleAvatar(
              //   radius: 40,
              //   backgroundColor: Colors.white,
              //   child: CircleAvatar(
              //     radius: 37,
              //     backgroundImage: NetworkImage(
              //       'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.jurusan,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
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
                user.universitas,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InformasiPribadiScreen()));
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            Icons.logout,
            'Sign Out',
            _showSignOutConfirmationDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
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
        height: 1, color: Colors.grey[200], indent: 16, endIndent: 16);
  }
}
