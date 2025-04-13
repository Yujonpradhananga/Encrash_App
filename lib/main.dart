import 'package:flutter/material.dart';
import 'Pages/encryption_page.dart';
import 'Pages/decryption_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData retroTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.greenAccent,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.greenAccent, fontFamily: 'Courier'),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.greenAccent),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.greenAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption/Decryption App',
      debugShowCheckedModeBanner: false,
      theme: retroTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/encryption': (context) => EncryptionPage(),
        '/decryption': (context) => DecryptionPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
        'Encrash',
        style: TextStyle(
            color: Colors.green[100], fontFamily: 'Courier', fontSize: 30),
      ))),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/encryption');
                },
                child: const Text(
                  'Encryption',
                  style: TextStyle(
                      fontFamily: 'Courier', color: Colors.black, fontSize: 30),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/decryption');
                },
                child: const Text(
                  'Decryption',
                  style: TextStyle(
                      fontFamily: 'Courier', color: Colors.black, fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
