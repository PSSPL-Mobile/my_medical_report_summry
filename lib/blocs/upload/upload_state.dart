import 'package:equatable/equatable.dart';
import 'package:my_medical_report_summry/models/report.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadSuccess extends UploadState {
  final Report reportData;

  const UploadSuccess(this.reportData);

  @override
  List<Object?> get props => [reportData];
}

class UploadFailure extends UploadState {
  final String error;

  const UploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}