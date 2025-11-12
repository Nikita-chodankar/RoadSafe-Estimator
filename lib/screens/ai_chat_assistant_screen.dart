import 'package:flutter/material.dart';

class AIChatAssistant extends StatefulWidget {
  const AIChatAssistant({Key? key}) : super(key: key);

  @override
  State<AIChatAssistant> createState() => _AIChatAssistantState();
}

class _AIChatAssistantState extends State<AIChatAssistant> {
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'message':
          'Hello! I\'m your AI assistant. Ask me anything about IRC standards, road safety interventions, or cost estimation.',
    },
  ];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _suggestions = [
    'Which IRC clause applies to guardrails?',
    'Explain bitumen rate calculation',
    'How is confidence score calculated?',
    'What are the IRC standards for speed bumps?',
  ];

  void _onUserMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': _messageController.text});
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'sender': 'ai',
          'message': _generateChatResponse(userMessage),
        });
      });
      _scrollToBottom();
    });
  }

  String _generateChatResponse(String query) {
    if (query.toLowerCase().contains('guardrail')) {
      return 'Guardrails are covered under IRC 119-3.2. They require steel beams with specific reflective properties. The standard spacing is 2m between posts with W-beam profile.';
    } else if (query.toLowerCase().contains('bitumen')) {
      return 'Bitumen rates are calculated based on CPWD SOR rates, which are updated quarterly. Current rate for bitumen mix is approximately ₹6,000 per ton, varying by grade and region.';
    } else if (query.toLowerCase().contains('confidence')) {
      return 'Confidence score is calculated based on the AI\'s certainty in matching interventions to IRC clauses and material specifications. Scores above 90% indicate high confidence, 70-90% medium, and below 70% low confidence.';
    } else if (query.toLowerCase().contains('speed bump')) {
      return 'Speed bumps are covered under IRC 67-5.1. Standard dimensions are 3.7m width, 10cm height with parabolic profile. Material typically includes bitumen concrete or rubber compounds.';
    } else {
      return 'I understand your question about "${query}". Based on IRC standards and current cost data, I can help you with specific information. Could you provide more details?';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _messageController.text = suggestion;
    _onUserMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  'sender': 'ai',
                  'message':
                      'Hello! I\'m your AI assistant. Ask me anything about IRC standards, road safety interventions, or cost estimation.',
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_messages.length == 1)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suggested Questions:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _suggestions.map((suggestion) {
                      return GestureDetector(
                        onTap: () => _onSuggestionTap(suggestion),
                        child: Chip(
                          label: Text(suggestion),
                          backgroundColor: Colors.blue[50],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF1976D2)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _onUserMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF1976D2),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _onUserMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
