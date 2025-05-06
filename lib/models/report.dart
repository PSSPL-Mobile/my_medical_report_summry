import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

// Model for a medical report
@JsonSerializable()
class Report {
  final int id;
  final String title;
  final String summary;
  final String suggestions;
  final String date;
  final Map<String, dynamic> metrics;

  Report({
    required this.id,
    required this.title,
    required this.summary,
    required this.suggestions,
    required this.date,
    required this.metrics,
  });

  // JSON serialization
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
