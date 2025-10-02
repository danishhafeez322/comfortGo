import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String text;

  const ProgressDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.black),
              SizedBox(height: 16),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
