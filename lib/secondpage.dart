import 'package:flutter/material.dart';

class MySecondPage extends StatelessWidget {
  const MySecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World from Second Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },  // added this comma
              child: Text('Go to Back to homepage'),
            ),
          ],
        ),
      ),
    );
  }
}