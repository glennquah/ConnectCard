import 'package:flutter/material.dart';

Color bgColor = const Color(0xffFEAA1B);

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> lines = text.split('\n');
    final List<String> filteredLines = [];
    final List<String> remainingLines = [];

    for (final line in lines) {
      if (line.contains('www.')) {
        filteredLines.add('Website: $line');
      } else if (RegExp(r'\d{4,}').hasMatch(line)) {
        filteredLines.add('Phone Number: $line');
      } else if (line.contains('@')) {
        filteredLines.add('Email: $line');
      } else {
        remainingLines.add(line);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Scanned NameCard Information'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtered Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredLines.length,
              itemBuilder: (context, index) {
                final line = filteredLines[index];
                return Text(line);
              },
            ),
            SizedBox(height: 16),
            Text(
              'Remaining Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: remainingLines.length,
              itemBuilder: (context, index) {
                return Text(remainingLines[index]);
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Card Type'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.person),
                              title: const Text('Personal Card'),
                              onTap: () {
                                // Handle personal card selection
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.group),
                              title: const Text('Friend Card'),
                              onTap: () {
                                // Handle friend card selection
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Add Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
