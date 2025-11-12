import 'package:flutter/material.dart';
import 'package:roadsafe_estimator/screens/detailed_report_view_screen.dart';

class SavedReportsScreen extends StatefulWidget {
  const SavedReportsScreen({Key? key}) : super(key: key);

  @override
  State<SavedReportsScreen> createState() => _SavedReportsScreenState();
}

class _SavedReportsScreenState extends State<SavedReportsScreen> {
  final List<Map<String, dynamic>> _reports = [
    {
      'name': 'NH-45 Audit Report',
      'date': '10 Nov 2025',
      'confidence': 89,
      'status': 'Completed',
    },
    {
      'name': 'City Road Safety Analysis',
      'date': '08 Nov 2025',
      'confidence': 92,
      'status': 'Completed',
    },
    {
      'name': 'Highway Intervention Study',
      'date': '05 Nov 2025',
      'confidence': 85,
      'status': 'Completed',
    },
  ];

  void _onOpenReport(Map<String, dynamic> report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedReportView(
          estimations: [
            {
              'intervention': 'Guardrail',
              'material': 'Steel Beam',
              'qty': '12 m',
              'rate': '₹450/m',
              'total': '₹5,400',
              'irc': 'IRC 119-3.2',
              'confidence': 92,
            },
          ],
        ),
      ),
    );
  }

  void _onDeleteReport(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _reports.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Report deleted')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Reports')),
      body: _reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No saved reports',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1976D2),
                      child: Text(
                        '${report['confidence']}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      report['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('Date: ${report['date']}'),
                        Text('Status: ${report['status']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.visibility,
                            color: Color(0xFF1976D2),
                          ),
                          onPressed: () => _onOpenReport(report),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _onDeleteReport(index),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
