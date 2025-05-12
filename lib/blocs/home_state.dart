// Import Equatable for state equality checks and Report model.
import 'package:equatable/equatable.dart';
import '../models/report.dart';

/// Name : HomeScreenState
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Base class for HomeScreenBloc states, using Equatable for equality.
abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  // Define properties for equality comparison (empty by default).
  @override
  List<Object?> get props => [];
}

/// Name : HomeInitial
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Initial state before any action.
class HomeInitial extends HomeScreenState {}

/// Name : HomeLoading
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Loading state while fetching data.
class HomeLoading extends HomeScreenState {}

/// Name : HomeLoaded
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Loaded state with reports, hemoglobin data, and tips.
class HomeLoaded extends HomeScreenState {
  // List of medical reports.
  List<Report> reports;
  // Hemoglobin data for graph display.
  List<Map<String, dynamic>> hemoglobinData;
  // Health tips based on reports.
  List<String> tips;

  HomeLoaded({
    required this.reports,
    required this.hemoglobinData,
    required this.tips,
  });

  // Define properties for equality comparison.
  @override
  List<Object?> get props => [reports, hemoglobinData, tips];
}

/// Name : HomeError
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Error state with an error message.
class HomeError extends HomeScreenState {
  // Error message to display.
  final String message;

  const HomeError(this.message);

  // Define message for equality comparison.
  @override
  List<Object?> get props => [message];
}