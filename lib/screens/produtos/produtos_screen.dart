import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/screens/produtos/componentes/produto_list_tile.dart';
import 'package:provider/provider.dart';

class ProdutosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Produtos'),
       centerTitle: true,
      ),
      body: Consumer<ProdutoManager>(
        builder: (_, produtoManager, __){
          return ListView.builder(
            padding: EdgeInsets.all(4),
            itemCount: produtoManager.todosProdutos.length,
            itemBuilder: (_, index){
              return ProdutoListTile(produto: produtoManager.todosProdutos[index],);
            },
          );
        },
      ),
    );
  }
}
