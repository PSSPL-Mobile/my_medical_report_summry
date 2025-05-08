import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_state.dart';
import 'package:my_medical_report_summry/blocs/tips/tips_cubit.dart';
import 'package:my_medical_report_summry/blocs/tips/tips_state.dart';
import 'package:my_medical_report_summry/constants.dart';

import '../models/report.dart';
import '../services/gemini_service.dart';

class TipsScreen extends StatelessWidget {
  final List<Report> reports;

  const TipsScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TipsCubit(GeminiService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health Tips'),
          backgroundColor: AppConstants.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personalized Health Tips',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              BlocBuilder<TipsCubit, TipsState>(
                builder: (context, state) {
                  if (state is TipsLoading) {
                    // Trigger fetching tips when the screen is first built
                    context.read<TipsCubit>().fetchTips(reports);
                  }
                  if (state is TipsLoading) {
                    return Expanded(child: const Center(child: CircularProgressIndicator()));
                  } else if (state is TipsLoaded) {
                    final tips = state.tips;
                    if (tips.isEmpty) {
                      return const Center(child: Text('No tips available.'));
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: tips.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tips[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is TipsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No tips available.'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}