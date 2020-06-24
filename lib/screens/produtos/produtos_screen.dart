import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/produto_manager.dart';
import 'package:lojavirtualgigabyte/screens/produtos/componentes/dialogo_pesquisa.dart';
import 'package:lojavirtualgigabyte/screens/produtos/componentes/produto_list_tile.dart';
import 'package:provider/provider.dart';

class ProdutosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProdutoManager>(
          builder: (_, produtoManager, __){
            if(produtoManager.pesquisa.isEmpty){
              return const Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, constrains){
                  return GestureDetector(
                    child: Container(
                        child: Text(produtoManager.pesquisa),
                      width: constrains.biggest.width,
                    ),
                    onTap: () async {
                      final pesquisa = await showDialog<String>(context: context, builder: (_) => DialogoPesquisa(
                        produtoManager.pesquisa
                      ));
                      if(pesquisa != null){
                        produtoManager.pesquisa = pesquisa;
                      }
                    },
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ProdutoManager>(
            builder: (_, produtoManager, __){
              if(produtoManager.pesquisa.isEmpty){
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final pesquisa = await showDialog<String>(context: context, builder: (_) => DialogoPesquisa(produtoManager.pesquisa
                    ));
                    if(pesquisa != null){
                      produtoManager.pesquisa = pesquisa;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    produtoManager.pesquisa = '';
                  },
                );
              }
            },
          )
        ],
      ),
      body: Consumer<ProdutoManager>(
        builder: (_, produtoManager, __){
          final produtosFiltrados = produtoManager.produtosFiltrados();
          return ListView.builder(
            padding: EdgeInsets.all(4),
            itemCount: produtosFiltrados.length,
            itemBuilder: (_, index){
              return ProdutoListTile(produto: produtosFiltrados[index],);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.of(context).pushNamed('/carrinho');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
