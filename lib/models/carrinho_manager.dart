import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/user.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';

class CarrinhoManager extends ChangeNotifier {

  List<CarrinhoProduto> itens = [];

  User user;
  num precoProdutos = 0.0;

  void updateUser(UserManager userManager){
      user = userManager.user;
      itens.clear();
      if(user != null){
        _carregaCarrinhoItens();
      }
  }

  Future<void>_carregaCarrinhoItens() async {
    final QuerySnapshot carSnap = await user.carrinhoRef.getDocuments();
    itens = carSnap.documents.map((c) => CarrinhoProduto.fromDocumento(c)..addListener(_onItemUpdate)).toList();
  }

  void addAoCarrinho(Produto produto){
    try {
      final e = itens.firstWhere((element) => element.podeJuntarItem(produto));
      e.incrementar();
    } catch(e){
      final carrinhoProduto = CarrinhoProduto.fromProduto(produto);
      carrinhoProduto.addListener(_onItemUpdate);
      itens.add(carrinhoProduto);
      user.carrinhoRef.add(carrinhoProduto.carrinhoItemMap()).then((value) => carrinhoProduto.id = value.documentID);
      _onItemUpdate();
    }
    notifyListeners();
  }

  void removerDoCarrinho(CarrinhoProduto carrinhoProduto){
    itens.removeWhere((element) => element.id == carrinhoProduto.id);
    user.carrinhoRef.document(carrinhoProduto.id).delete();
    carrinhoProduto.removeListener(_onItemUpdate);
    notifyListeners();
  }

  void _onItemUpdate(){
    precoProdutos = 0.0;

    for(int i = 0; i < itens.length; i++){
      final carrinho = itens[i];
      if(carrinho.quantidade == 0){
        removerDoCarrinho(carrinho);
        i--;
        continue;
      }
      precoProdutos += carrinho.precoTotal;
      _updateCarrinhoProduto(carrinho);
    }
    notifyListeners();
  }

  void _updateCarrinhoProduto(CarrinhoProduto carrinhProduto){
    if(carrinhProduto.id != null)
      user.carrinhoRef.document(carrinhProduto.id).updateData(carrinhProduto.carrinhoItemMap());
  }

  bool get isCarrinhoValido {
    for(final carrinhoProduto in itens){
      if(!carrinhoProduto.temEstoque) return false;
    }
    return true;
  }
}