import 'package:flutter/material.dart';

class counterScreen extends StatefulWidget {
  @override
  State<counterScreen> createState() => _counterScreenState();
}

class _counterScreenState extends State<counterScreen> {
  int counter = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('counter'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  counter--;
                });
              },
              child: Text('Minus'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '$counter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: Text('PLUS'),
            ),
          ],
        ),
      ),
    );
  }
}
