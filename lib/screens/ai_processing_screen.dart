import 'package:flutter/material.dart';
import 'package:roadsafe_estimator/screens/material_cost_estimation_screeen.dart';

class AIProcessingScreen extends StatefulWidget {
  final String fileName;

  const AIProcessingScreen({Key? key, required this.fileName})
    : super(key: key);

  @override
  State<AIProcessingScreen> createState() => _AIProcessingScreenState();
}

class _AIProcessingScreenState extends State<AIProcessingScreen> {
  final List<String> _logs = [];
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _processData();
  }

  Future<void> _processData() async {
    await _addLog('Reading report...', 0.2);
    await _addLog('Extracting interventions...', 0.4);
    await _addLog('Identifying IRC references...', 0.6);
    await _addLog('Fetching material rates...', 0.8);
    await _addLog('Calculating confidence scores...', 0.9);
    await _addLog('Processing complete!', 1.0);

    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MaterialCostEstimationScreen(),
      ),
    );
  }

  Future<void> _addLog(String log, double progress) async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _logs.add(log);
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Processing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy, size: 100, color: Color(0xFF1976D2)),
            const SizedBox(height: 30),
            const Text(
              'Analyzing Your Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'File: ${widget.fileName}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 10),
            Text('${(_progress * 100).toInt()}% Complete'),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(_logs[index])),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
