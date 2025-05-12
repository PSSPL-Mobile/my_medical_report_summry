import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_medical_report_summry/screens/home_screen.dart';
import 'package:my_medical_report_summry/services/gemini_service.dart';

import 'blocs/home_bloc.dart';

/// Name : main.dart
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Initializes the app and loads environment variables before running.
Future<void> main() async {
  // Ensure Flutter bindings are initialized before loading the environment file.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file located in assets.
  await dotenv.load(fileName: 'assets/.env');

  // Start the app.
  runApp(const MyApp());
}

// Section: MyApp Widget
// The root widget of the application, setting up the app's theme and BLoC providers.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Section: App Setup
    // Configures the BLoC provider and material app with theme and home screen.
    return MultiBlocProvider(
      providers: [
        // Provide the HomeScreenBloc with a GeminiService instance for report analysis.
        BlocProvider<HomeScreenBloc>(
          create: (context) => HomeScreenBloc(GeminiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Medical Report Summary', // App title for display in system UI.
        theme: ThemeData(
          primarySwatch: Colors.blue, // Primary color theme for the app.
          useMaterial3: true, // Enable Material 3 design system.
        ),
        home: const HomeScreen(), // Set the home screen as the initial route.
      ),
    );
  }
}
