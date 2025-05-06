/*
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/report.dart';
import '../../services/gemini_service.dart';
import '../../services/report_service.dart';
import 'report_event.dart';
import 'report_state.dart';

// BLoC for managing reports
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService reportService;
  final GeminiService geminiService;

  ReportBloc(this.reportService, this.geminiService) : super(ReportInitial()) {
    // Handle loading reports
    on<LoadReports>(_onLoadReports);
    // Handle uploading a new report
    on<UploadReport>(_onUploadReport);
  }

  // Load static reports from JSON
  Future<void> _onLoadReports(LoadReports event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoading());
      final reports = await reportService.loadReports();
      emit(ReportsLoaded(reports));
    } catch (e) {
      emit(ReportError('Failed to load reports: $e'));
    }
  }

  // Process and upload a new report
  Future<void> _onUploadReport(UploadReport event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoading());
      // Simulate Gemini AI processing
      final analysis = await geminiService.analyzeReport(event.file);
      // Add new report
      final newReport = Report(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'Report - ${DateTime.now().toString().substring(0, 10)}',
        summary: analysis['summary'],
        suggestions: analysis['suggestions'],
        date: DateTime.now().toString().substring(0, 10),
        metrics: Map<String, dynamic>.from(analysis['metrics']),
      );
      final reports = await reportService.addReport(newReport);
      emit(ReportsLoaded(reports));
    } catch (e) {
      emit(ReportError('Failed to upload report: $e'));
    }
  }
}*/
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_event.dart';
import 'package:my_medical_report_summry/blocs/report/report_state.dart';

import '../../models/report.dart';
import '../../services/report_service.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {

  final ReportService reportService;
  List<Report> _reports = []; // In-memory storage for reports

  ReportBloc(this.reportService) : super(ReportInitial()) {
    on<LoadReports>(_onLoadReports);
    on<UpdateReports>(_onUpdateReports);
  }

  Future<void> _onLoadReports(LoadReports event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      _reports = await reportService.loadReports();
      emit(ReportsLoaded(_reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onUpdateReports(UpdateReports event, Emitter<ReportState> emit) async {
    _reports.add(event.reportData);
    emit(ReportsLoaded(_reports));
  }
}
