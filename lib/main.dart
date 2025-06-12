// lib/main.dart (Simplified without Provider and Dark Mode)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unitime/screens/home/home_screen.dart';
import 'package:unitime/screens/profile/profile_screen.dart';
import 'package:unitime/screens/schedule/schedule_screen.dart';
import 'package:unitime/screens/splash/splash_screen.dart';
import 'package:unitime/utils/app_colors.dart';
import 'package:unitime/widgets/bottom_nav_bar.dart';

void main() {
  // Langsung jalankan MyApp, tanpa ChangeNotifierProvider
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tidak perlu lagi Consumer, langsung return MaterialApp
    return MaterialApp(
      title: 'Study App',

      // Hanya satu tema yang didefinisikan
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Menegaskan ini tema terang
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

      // Properti darkTheme dan themeMode dihapus
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/main': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Tidak ada perubahan di bawah ini
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

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
