// Import Equatable for event equality checks.
import 'package:equatable/equatable.dart';

/// Name : HomeScreenEvent
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Base class for HomeScreenBloc events, using Equatable for equality.
abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  // Define properties for equality comparison (empty by default).
  @override
  List<Object?> get props => [];
}

/// Name : HomeLoadReports
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Event to load medical reports for the HomeScreen.
class HomeLoadReports extends HomeScreenEvent {
  const HomeLoadReports();

  // No properties, so props is empty for equality checks.
  @override
  List<Object?> get props => [];
}
