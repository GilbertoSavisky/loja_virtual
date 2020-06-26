import 'package:flutter/material.dart';

class CustonIconButton extends StatelessWidget {

  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  const CustonIconButton({this.iconData, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}