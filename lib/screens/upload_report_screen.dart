import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:roadsafe_estimator/screens/ai_processing_screen.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({Key? key}) : super(key: key);

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {
  File? _selectedFile;
  bool _includeIRC = true;
  final _textController = TextEditingController();
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _onFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _onUploadClick() async {
    if (_selectedFile == null && _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file or enter text')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _uploadProgress = i / 100;
      });
    }

    // Navigate to processing screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIProcessingScreen(
          fileName: _selectedFile?.path.split('/').last ?? 'Text Input',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload Intervention Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _onFileUpload,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedFile == null
                            ? Icons.cloud_upload
                            : Icons.check_circle,
                        size: 60,
                        color: _selectedFile == null
                            ? Colors.grey
                            : Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedFile == null
                            ? 'Drag & Drop or Click to Browse'
                            : 'File: ${_selectedFile!.path.split('/').last}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Supported: PDF, DOCX, TXT',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'OR Paste Text Directly',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Paste your report text here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Include IRC Standard References'),
              value: _includeIRC,
              onChanged: (value) => setState(() => _includeIRC = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),
            if (_isUploading)
              Column(
                children: [
                  LinearProgressIndicator(value: _uploadProgress),
                  const SizedBox(height: 10),
                  Text('Uploading... ${(_uploadProgress * 100).toInt()}%'),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _onUploadClick,
              icon: const Icon(Icons.upload),
              label: const Text('Upload & Extract Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
