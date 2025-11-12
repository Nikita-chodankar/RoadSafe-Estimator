import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DetailedReportView extends StatefulWidget {
  final List<Map<String, dynamic>> estimations;

  const DetailedReportView({Key? key, required this.estimations})
    : super(key: key);

  @override
  State<DetailedReportView> createState() => _DetailedReportViewState();
}

class _DetailedReportViewState extends State<DetailedReportView> {
  bool _showRationale = false;

  Future<void> _onDownloadDetailedPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Detailed Cost Estimation Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
              pw.Divider(),
              ...widget.estimations.map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 15),
                    pw.Text(
                      item['intervention'],
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('Material: ${item['material']}'),
                    pw.Text('Quantity: ${item['qty']}'),
                    pw.Text('Rate: ${item['rate']}'),
                    pw.Text('Total: ${item['total']}'),
                    pw.Text('IRC Clause: ${item['irc']}'),
                    pw.Text('Confidence: ${item['confidence']}%'),
                    pw.Divider(),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/detailed_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Detailed PDF saved to ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _onShareReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Report'),
        content: const Text(
          'Shareable link generated:\nhttps://roadsafe.example.com/report/12345',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Copy Link'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Report'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _onShareReport),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _onDownloadDetailedPDF,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Intervention Analysis Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Generated on: ${DateTime.now().toString().split('.')[0]}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Show AI Rationale'),
              value: _showRationale,
              onChanged: (value) => setState(() => _showRationale = value),
            ),
            const SizedBox(height: 20),
            ...widget.estimations.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['intervention'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _SectionTitle(title: 'Material Specification'),
                      Text('Material: ${item['material']}'),
                      Text('Quantity Required: ${item['qty']}'),
                      const SizedBox(height: 15),
                      _SectionTitle(title: 'Cost Breakdown'),
                      Text('Unit Rate: ${item['rate']}'),
                      Text(
                        'Total Cost: ${item['total']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _SectionTitle(title: 'IRC Reference'),
                      Text('Clause: ${item['irc']}'),
                      const SizedBox(height: 15),
                      _SectionTitle(title: 'Confidence Score'),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: item['confidence'] / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getConfidenceColor(item['confidence']),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${item['confidence']}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (_showRationale) ...[
                        const SizedBox(height: 15),
                        _SectionTitle(title: 'AI Rationale'),
                        Text(
                          'This intervention was identified based on IRC ${item['irc']} specifications. '
                          'The material cost is calculated using current CPWD SOR rates. '
                          'Confidence score indicates the accuracy of IRC clause matching and material identification.',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 90) return Colors.green;
    if (confidence >= 70) return Colors.orange;
    return Colors.red;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
