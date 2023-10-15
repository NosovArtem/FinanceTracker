import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/helper.dart';

class FeedbackPage extends StatefulWidget {
  @override
  FeedbackPageState createState() => FeedbackPageState();
}

class FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  int _selectedSmiley = 2;

  final List<IconData> _smileys = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  double _smileySize = 64.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 500) {
      _smileySize = 32.0;
    } else if (screenWidth < 800) {
      _smileySize = 64.0;
    } else {
      _smileySize = 128.0;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Отправить обратную связь'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _smileys.asMap().entries.map((entry) {
                  final index = entry.key;
                  final smiley = entry.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSmiley = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        smiley,
                        size: _smileySize,
                        color: _selectedSmiley == index
                            ? Colors.purple
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            TextField(
              controller: _emailController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Email Address:',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Feedback:',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendFeedback();
              },
              child: Text('Отправить обратную связь'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendFeedback() {
    final email = _emailController.text;
    final feedback = _feedbackController.text;
    sendEmail('Тема сообщения', email + " " + feedback);
  }

}
