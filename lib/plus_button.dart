import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({Key? key, this.function}) : super(key: key);
  final function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(100)),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
