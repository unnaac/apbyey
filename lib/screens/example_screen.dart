import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Screen',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: AnimatedButton(
          label: 'Click Me',
          onPressed: () {
            // Handle button press
          },
        ),
      ),
    );
  }
}
