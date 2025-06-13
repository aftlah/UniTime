import 'package:flutter/material.dart';

/// Membuat transisi halaman dengan efek geser dari kanan dan memudar.
///
/// Ini memberikan animasi yang halus dan modern untuk navigasi standar.
///
/// [page]: Widget atau halaman tujuan.
Route createSlideFadeRoute(Widget page) {
  return PageRouteBuilder(
    // Halaman tujuan yang akan ditampilkan
    pageBuilder: (context, animation, secondaryAnimation) => page,
    
    // Durasi animasi transisi
    transitionDuration: const Duration(milliseconds: 400),
    
    // Builder untuk membuat animasi kustom
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Tentukan posisi awal (off-screen di kanan) dan akhir (on-screen)
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      
      // Gunakan kurva untuk membuat gerakan lebih alami (mulai cepat, melambat di akhir)
      const curve = Curves.easeOutCubic;

      // Buat Tween untuk menginterpolasi nilai Offset berdasarkan kurva
      var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var slideAnimation = animation.drive(slideTween);
      
      // Buat Tween untuk animasi memudar (fade-in)
      var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      var fadeAnimation = animation.drive(fadeTween.chain(CurveTween(curve: Curves.easeIn)));

      // Gabungkan kedua animasi menggunakan FadeTransition dan SlideTransition
      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child, // 'child' adalah halaman tujuan
        ),
      );
    },
  );
}


/// Membuat transisi halaman dengan efek memudar (fade) saja.
///
/// Berguna untuk transisi yang lebih sederhana dan tidak terlalu mencolok.
///
/// [page]: Widget atau halaman tujuan.
Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Cukup bungkus halaman tujuan (child) dengan FadeTransition.
      // 'animation' yang disediakan oleh PageRouteBuilder secara otomatis
      // bernilai dari 0.0 hingga 1.0.
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}