/*
import 'package:equatable/equatable.dart';
import '../../models/report.dart';

// States for report management
abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

// Initial state
class ReportInitial extends ReportState {}

// Loading reports
class ReportLoading extends ReportState {}

// Error occurred
class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}

// Reports loaded successfully
class ReportsLoaded extends ReportState {
  final List<Report> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}*/
import 'package:equatable/equatable.dart';

import '../../models/report.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportsLoaded extends ReportState {
  final List<Report> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class ReportLoaded extends ReportState {
  final List<Report> reportData;

  const ReportLoaded(this.reportData);

  @override
  List<Object?> get props => [reportData];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}