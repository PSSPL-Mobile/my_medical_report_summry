/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/report/report_bloc.dart';
import 'blocs/report/report_event.dart';
import 'constants.dart';
import 'screens/home_screen.dart';
import 'services/gemini_service.dart';
import 'services/report_service.dart';

// App entry point
Future<void> main() async {
 */
/* try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('Failed to load .env file: $e. Using default or mock API key.');
    // Optionally set a default API key or mock mode
    dotenv.env['GEMINI_API_KEY'] = 'mock-api-key';
  }*//*

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Report App',
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppConstants.secondaryColor,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_medical_report_summry/screens/home_screen.dart';
import 'package:my_medical_report_summry/services/gemini_service.dart';
import 'package:my_medical_report_summry/blocs/report/report_bloc.dart';
import 'package:my_medical_report_summry/blocs/upload/upload_cubit.dart';

Future<void> main() async {
/*  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('Failed to load .env file: $e. Using default or mock API key.');
    dotenv.env['GEMINI_API_KEY'] = 'mock-api-key';
  }*/
  await dotenv.load(fileName: 'assets/.env');
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'AIzaSyBd-CXnJYyIwGXm9e4qQhz3RprnFPGww5U';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReportBloc>(
          create: (context) => ReportBloc(GeminiService()),
        ),
        BlocProvider<UploadCubit>(
          create: (context) => UploadCubit(GeminiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Medical Report Summary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}