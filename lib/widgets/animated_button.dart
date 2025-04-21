import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed; // Nullable to handle disabled state

  const AnimatedButton({required this.label, this.onPressed, Key? key})
      : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: (_) {
        if (!isDisabled) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (!isDisabled) setState(() => _isPressed = false);
      },
      onTapCancel: () {
        if (!isDisabled) setState(() => _isPressed = false);
      },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.red[200] // Disabled state
              : _isPressed
                  ? Colors.red[700] // Pressed state
                  : Colors.red, // Default state
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: isDisabled
                  ? Colors.red[400] // Disabled text color
                  : Colors.white, // Default and pressed text color
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
