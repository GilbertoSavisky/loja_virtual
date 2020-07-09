import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';
import 'package:provider/provider.dart';

class CarrinhoTile extends StatelessWidget {

  final CarrinhoProduto carrinhoProduto;

  const CarrinhoTile(this.carrinhoProduto);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: carrinhoProduto,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed('/produto', arguments: carrinhoProduto.produto);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(carrinhoProduto.produto.imagens.first),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      children: [
                        Text(carrinhoProduto.produto.nome,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('Tamanho: ${carrinhoProduto.tamanho}', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Consumer<CarrinhoProduto>(
                          builder: (_, carrinhoProduto, __){
                            if(carrinhoProduto.temEstoque)
                              return Text('R\$ ${carrinhoProduto.precoUnico.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              );
                            else
                              return Text('Sem estoque suficiente', style: TextStyle(fontSize: 12, color: Colors.red),);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<CarrinhoProduto>(
                  builder: (_, carrinhoProduto, __){
                    return Column(
                      children: [
                        CustomIconButton(
                          iconData: Icons.add,
                          color: Theme.of(context).primaryColor,
                          onTap: carrinhoProduto.incrementar,
                        ),
                        Text('${carrinhoProduto.quantidade}', style: const TextStyle(fontSize: 20),),
                        CustomIconButton(
                          iconData: Icons.remove,
                          color: carrinhoProduto.quantidade > 1 ? Theme.of(context).primaryColor : Colors.red,
                          onTap: carrinhoProduto.decrementar,
                        ),

                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
