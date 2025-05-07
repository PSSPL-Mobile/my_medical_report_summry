part of 'graph_cubit.dart';

// State for the GraphCubit
abstract class GraphState {}

class GraphInitial extends GraphState {}

class GraphLoading extends GraphState {}

class GraphLoaded extends GraphState {
  final List<Map<String, dynamic>> hemoglobinData; // List of {value, day} for hemoglobin
  GraphLoaded(this.hemoglobinData);
}

class GraphError extends GraphState {
  final String message;

  GraphError(this.message);
}
