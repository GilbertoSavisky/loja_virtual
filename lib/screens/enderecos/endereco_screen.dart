import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/screens/enderecos/componentes/endereco_card.dart';

class EnderecoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          EnderecoCard(),
        ],
      ),
    );
  }
}
