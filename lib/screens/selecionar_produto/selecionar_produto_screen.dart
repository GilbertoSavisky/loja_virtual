import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:provider/provider.dart';

class SelecionarProdutoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vincular produto'),
        centerTitle: true,
      ),
      body: Consumer<ProdutoManager>(
        builder: (_, produtoManager, __){
          return ListView.builder(
            itemCount: produtoManager.todosProdutos.length,
            itemBuilder: (_, index){
              final produto = produtoManager.todosProdutos[index];
              return ListTile(
                title: Text(produto.nome),
                subtitle: Text('R\$ ${produto.precoBase.toStringAsFixed(2)}'),
                leading: Image.network(produto.imagens.first),
                onTap: (){
                  Navigator.of(context).pop(produto);
                },
              );
            },

          );
        },
      ),
    );
  }
}
