import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_medical_report_summry/blocs/report/report_bloc.dart';
import 'package:my_medical_report_summry/blocs/upload/upload_cubit.dart';
import 'package:my_medical_report_summry/screens/home_screen.dart';
import 'package:my_medical_report_summry/services/gemini_service.dart';

Future<void> main() async {
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