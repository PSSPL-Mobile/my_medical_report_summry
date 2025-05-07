import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_medical_report_summry/models/report.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class UploadReport extends ReportEvent {
  final PlatformFile file;

  const UploadReport(this.file);

  @override
  List<Object?> get props => [file];
}

class LoadReports extends ReportEvent {
  const LoadReports();
}

class UpdateReports extends ReportEvent {
  final Report reportData;

  const UpdateReports(this.reportData);

  @override
  List<Object?> get props => [reportData];
}