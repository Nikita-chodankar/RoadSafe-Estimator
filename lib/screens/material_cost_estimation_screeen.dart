import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:roadsafe_estimator/screens/detailed_report_view_screen.dart';

class MaterialCostEstimationScreen extends StatefulWidget {
  const MaterialCostEstimationScreen({Key? key}) : super(key: key);

  @override
  State<MaterialCostEstimationScreen> createState() =>
      _MaterialCostEstimationScreenState();
}

class _MaterialCostEstimationScreenState
    extends State<MaterialCostEstimationScreen> {
  final List<Map<String, dynamic>> _estimations = [
    {
      'intervention': 'Guardrail',
      'material': 'Steel Beam',
      'qty': '12 m',
      'rate': '₹450/m',
      'total': '₹5,400',
      'irc': 'IRC 119-3.2',
      'confidence': 92,
    },
    {
      'intervention': 'Speed Bump',
      'material': 'Bitumen Mix',
      'qty': '3 tons',
      'rate': '₹6,000/ton',
      'total': '₹18,000',
      'irc': 'IRC 67-5.1',
      'confidence': 87,
    },
    {
      'intervention': 'Road Signs',
      'material': 'Reflective Sheet',
      'qty': '15 sq.m',
      'rate': '₹800/sq.m',
      'total': '₹12,000',
      'irc': 'IRC 67-2.4',
      'confidence': 95,
    },
  ];

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 90) return Colors.green;
    if (confidence >= 70) return Colors.orange;
    return Colors.red;
  }

  void _onSaveReport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Report saved successfully!')));
  }

  Future<void> _onExportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Road Safety Cost Estimation Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'Intervention',
                  'Material',
                  'Qty',
                  'Rate',
                  'Total',
                  'IRC',
                  'Confidence',
                ],
                data: _estimations
                    .map(
                      (e) => [
                        e['intervention'],
                        e['material'],
                        e['qty'],
                        e['rate'],
                        e['total'],
                        e['irc'],
                        '${e['confidence']}%',
                      ],
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/cost_estimation_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF saved to ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost Estimation'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _onSaveReport),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _onExportPDF,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material Cost Breakdown',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _estimations.length,
              itemBuilder: (context, index) {
                final item = _estimations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['intervention'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getConfidenceColor(
                                  item['confidence'],
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${item['confidence']}%',
                                style: TextStyle(
                                  color: _getConfidenceColor(
                                    item['confidence'],
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(label: 'Material', value: item['material']),
                        _DetailRow(label: 'Quantity', value: item['qty']),
                        _DetailRow(label: 'Unit Rate', value: item['rate']),
                        _DetailRow(label: 'IRC Clause', value: item['irc']),
                        const Divider(),
                        _DetailRow(
                          label: 'Total Cost',
                          value: item['total'],
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailedReportView(estimations: _estimations),
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('View Detailed Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? const Color(0xFF1976D2) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
