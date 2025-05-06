import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_bloc.dart';
import 'package:my_medical_report_summry/blocs/report/report_event.dart';
import 'package:my_medical_report_summry/blocs/upload/upload_cubit.dart';
import 'package:my_medical_report_summry/blocs/upload/upload_state.dart';
import '../constants.dart';

// Screen for uploading a new report
class UploadReportScreen extends StatelessWidget {
  const UploadReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: BlocConsumer<UploadCubit, UploadState>(
            listener: (context, state) {
              if (state is UploadSuccess) {
                // Notify ReportBloc to update the report list
                context.read<ReportBloc>().add(UpdateReports(state.reportData));
                Navigator.of(context).pop();
              } else if (state is UploadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Upload Failed: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              if (state is UploadLoading) {
                return const CircularProgressIndicator();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Upload a PDF or Image',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'jpg', 'png'],
                      );
                      if (result != null && result.files.isNotEmpty) {
                        context.read<UploadCubit>().uploadReport(result.files.first);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Select File'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}