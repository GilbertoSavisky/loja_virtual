import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/screens/editar_produto/componentes/imagens_form.dart';

class EditarProduto extends StatelessWidget {

  final Produto produto;

  const EditarProduto(this.produto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ImagensForm(produto),
        ],
      ),
    );
  }
}
