// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      summary: json['summary'] as String,
      suggestions: json['suggestions'] as String,
      date: json['date'] as String,
      metrics: json['metrics'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'suggestions': instance.suggestions,
      'date': instance.date,
      'metrics': instance.metrics,
    };
