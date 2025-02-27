import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/auth/AuthProvider.dart' as my_auth;
import 'package:ta_bultang/firebase_options.dart';
import 'package:ta_bultang/auth/RegisterScreen.dart';
import 'package:ta_bultang/auth/LoginScreen.dart';
import 'package:ta_bultang/lapangan/LapanganProvider.dart';
import 'package:ta_bultang/booking/BookingProvider.dart';
import 'package:ta_bultang/menu/BottomNavBar.dart';
import 'package:ta_bultang/menu/CommunityProvider.dart';
import 'package:ta_bultang/history/HistoryProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi WebView berdasarkan platform
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  } else if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<my_auth.AuthProvider>(create: (_) => my_auth.AuthProvider()),
        ChangeNotifierProvider<LapanganProvider>(create: (_) => LapanganProvider()),
        ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
        ChangeNotifierProvider<CommunityProvider>(create: (_) => CommunityProvider()),
        ChangeNotifierProvider<HistoryProvider>(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Registerscreen(),
        routes: {
          '/login': (context) => const Loginscreen(),
          '/home': (context) => const BottomNavBar(),
        },
      ),
    );
  }
}