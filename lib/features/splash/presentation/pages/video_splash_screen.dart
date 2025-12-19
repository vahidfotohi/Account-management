// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:go_router/go_router.dart';
//
// class VideoSplashScreen extends StatefulWidget {
//   const VideoSplashScreen({super.key});
//
//   @override
//   State<VideoSplashScreen> createState() => _VideoSplashScreenState();
// }
//
// class _VideoSplashScreenState extends State<VideoSplashScreen> {
//   late VideoPlayerController _controller;
//   bool _initialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // 1. آدرس دهی به فایل ویدیو
//     _controller = VideoPlayerController.asset('assets/intro.mp4')
//       ..initialize().then((_) {
//         // 2. تنظیمات اولیه
//         setState(() {
//           _initialized = true;
//         });
//         _controller.setVolume(0.0); // معمولاً اسپلش صدا ندارد
//         _controller.play(); // پخش خودکار
//       });
//
//     // 3. گوش دادن به پایان ویدیو برای رفتن به صفحه بعد
//     _controller.addListener(() {
//       if (_controller.value.position >= _controller.value.duration) {
//         _navigateToHome();
//       }
//     });
//   }
//
//   void _navigateToHome() {
//     // جلوگیری از اجرای چندباره
//     if (!mounted) return;
//     // هدایت به صفحه اصلی (مسیر '/' یا '/home' بسته به روتر شما)
//     context.go('/');
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E293B), // رنگ پس‌زمینه ویدیو (سرمه‌ای تم)
//       body: Center(
//         child: _initialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : const SizedBox(), // تا قبل از لود شدن چیزی نشان نده (یا یک عکس بگذارید)
//       ),
//     );
//   }
// }