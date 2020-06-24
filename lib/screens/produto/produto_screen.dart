import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/carrinho_manager.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/screens/produto/componentes/tamanho_widget.dart';
import 'package:provider/provider.dart';

class ProdutoScreen extends StatelessWidget {

  final Produto produto;

  const ProdutoScreen(this.produto);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: produto,
      child: Scaffold(
        appBar: AppBar(
          title: Text(produto.nome, overflow: TextOverflow.ellipsis, maxLines: 1,),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,

        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images:
                  produto.imagens.map((i){
                    return NetworkImage(i);
                  }).toList(),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    produto.nome, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('A partir de', style: TextStyle(fontSize: 13, color: Colors.grey[600]),),
                  ),
                  Text('R\$ 19.99', style: TextStyle(fontSize: 22, color: primaryColor, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text('Descrição', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                  Container(
                    child: Stack(
                      overflow: Overflow.clip,
                      children: [
                        FlatButton(
                          child: Text('mais'),
                        ),
                        Container(
                          child: Text(produto.descricao,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text('Tamanhos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: produto.tamanhos.map((t) =>
                      TamanhoWidget(tamanho: t),
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  if(produto.temEstoque)
                    Consumer2<UserManager, Produto>(
                      builder: (_, userManager, produto, __){
                        return SizedBox(height: 44,
                          child: RaisedButton(
                            onPressed: produto.tamanhoSelecionado !=null ? (){
                              if(userManager.isLoggedin){
                                context.read<CarrinhoManager>().addAoCarrinho(produto);
                                Navigator.of(context).pushNamed('/carrinho');
                              }
                                else
                                  Navigator.of(context).pushNamed('/login');
                            } : null,
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(userManager.isLoggedin ? 'Adicionar ao carrinho' : 'Entre para Comprar', style: const TextStyle(fontSize: 18),),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
