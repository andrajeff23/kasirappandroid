import 'package:flutter/material.dart';

class LoadingAppWidget extends StatelessWidget {
  const LoadingAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SizedBox(
          width: 50, height: 50, child: CircularProgressIndicator(color: Colors.greenAccent.withOpacity(0.8),)),
    );
  }
}
