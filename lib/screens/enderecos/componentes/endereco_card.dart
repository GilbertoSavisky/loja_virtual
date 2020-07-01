import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:lojavirtualgigabyte/screens/enderecos/componentes/cep_input_field.dart';
import 'package:lojavirtualgigabyte/screens/enderecos/componentes/endereco_input_field.dart';
import 'package:provider/provider.dart';

class EnderecoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CarrinhoManager>(
          builder: (_, carrinhoManager, __){

            final endereco = carrinhoManager.endereco ?? Endereco();
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Endereço de Entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),

                  CepInputField(endereco: endereco),
                  EnderecoInputField(endereco: endereco),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
