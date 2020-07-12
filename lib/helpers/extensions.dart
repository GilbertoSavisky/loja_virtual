import 'package:flutter/material.dart';

extension Extra on TimeOfDay{
  String formatarTime(){
    return '${hour}:${minute.toString().padLeft(2, '0')}';
  }

  int toMinutos() => hour*60 + minute;
}