import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/secao.dart';

class SecaoHeader extends StatelessWidget {

  final Secao secao;

  const SecaoHeader({this.secao});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(secao.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),),
    );
  }
}
