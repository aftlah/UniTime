// lib/main.dart (Kode Lengkap)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitime/screens/auth/login/login_screen.dart';
import 'package:unitime/screens/home/home_screen.dart';
import 'package:unitime/screens/profile/profile_screen.dart';
import 'package:unitime/screens/schedule/schedule_screen.dart';
import 'package:unitime/screens/splash/splash_screen.dart';
import 'package:unitime/utils/app_colors.dart';
import 'package:unitime/widgets/bottom_nav_bar.dart';
import 'package:unitime/screens/task/task_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        // Anda mungkin tidak lagi memerlukan route ini jika navigasi
        // hanya terjadi di dalam MainScreen
        '/tugas': (context) => const TugasScreen(),
        '/jadwal': (context) => const JadwalScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      // Teruskan fungsi ke HomeScreen yang memicu perubahan tab
      // Saat tombol di CoursesCard ditekan, fungsi ini akan memanggil
      // _onItemTapped dengan indeks '2' (indeks TugasScreen).
      HomeScreen(
        onNavigateToTugas: () => _onItemTapped(2),
      ),
      const JadwalScreen(),
      const TugasScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
