import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final List<Map<String, dynamic>> _usageStats = [
    {'user': 'Nikita', 'reports': 24, 'lastAccess': '11 Nov 2025'},
    {'user': 'Rahul', 'reports': 18, 'lastAccess': '10 Nov 2025'},
    {'user': 'Priya', 'reports': 31, 'lastAccess': '09 Nov 2025'},
  ];

  Future<void> _updateDataset() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'json', 'csv'],
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dataset updated: ${result.files.single.name}')),
      );
    }
  }

  Future<void> _updateCostSources() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Cost Sources'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'CPWD SOR URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'GeM Portal URL',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cost sources updated successfully'),
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _AdminStatCard(
                    title: 'Total Users',
                    value: '156',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _AdminStatCard(
                    title: 'Total Reports',
                    value: '1,248',
                    icon: Icons.description,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _AdminStatCard(
                    title: 'API Calls',
                    value: '3,567',
                    icon: Icons.api,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _AdminStatCard(
                    title: 'Avg. Accuracy',
                    value: '87%',
                    icon: Icons.analytics,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Data Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.upload_file, color: Colors.blue),
                    title: const Text('Upload IRC Dataset'),
                    subtitle: const Text('Update IRC standards database'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _updateDataset,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ),
                    title: const Text('Update Cost Sources'),
                    subtitle: const Text('CPWD SOR & GeM Portal links'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _updateCostSources,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.refresh, color: Colors.orange),
                    title: const Text('Refresh Material Rates'),
                    subtitle: const Text('Update current market prices'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Material rates refreshed'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'User Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Reports')),
                  DataColumn(label: Text('Last Access')),
                ],
                rows: _usageStats.map((stat) {
                  return DataRow(
                    cells: [
                      DataCell(Text(stat['user'])),
                      DataCell(Text('${stat['reports']}')),
                      DataCell(Text(stat['lastAccess'])),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'System Logs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LogEntry(
                      time: '11:30 AM',
                      message: 'User Nikita uploaded new report',
                      type: 'info',
                    ),
                    _LogEntry(
                      time: '11:15 AM',
                      message: 'Material rates updated successfully',
                      type: 'success',
                    ),
                    _LogEntry(
                      time: '10:45 AM',
                      message: 'API rate limit reached for user Rahul',
                      type: 'warning',
                    ),
                    _LogEntry(
                      time: '10:30 AM',
                      message: 'IRC dataset updated',
                      type: 'success',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogEntry extends StatelessWidget {
  final String time;
  final String message;
  final String type;

  const _LogEntry({
    required this.time,
    required this.message,
    required this.type,
  });

  Color _getTypeColor() {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_getTypeIcon(), color: _getTypeColor(), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(fontSize: 14)),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
