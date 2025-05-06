import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/upload/upload_state.dart';

import '../../models/report.dart';
import '../../services/report_service.dart';

class UploadCubit extends Cubit<UploadState> {
  final ReportService reportService;
  final List<Report> _reports = []; // In-memory storage for reports

  UploadCubit(this.reportService) : super(UploadInitial());

  Future<void> uploadReport(PlatformFile file) async {
    emit(UploadLoading());
    try {
      Map<String, dynamic> reportData = await reportService.analyzeReport(file);
      var report = _addReport(reportData);
      emit(UploadSuccess(report));
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }

  List<Report> loadReports() {
    return _reports;
  }

  Report _addReport(Map<String, dynamic> reportData) {
    var report = Report(
      id: reportData['id'] as int,
      title: reportData['title'] as String,
      summary: reportData['summary'] as String,
      suggestions: reportData['suggestions'] as String,
      date: reportData['date'] as String,
      metrics: Map<String, dynamic>.from(reportData['metrics'] as Map),
    );
    _reports.add(report);
    return report;
  }
}
