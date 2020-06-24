import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/user.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';

class CarrinhoManager{

  List<CarrinhoProduto> itens = [];

  User user;

  void updateUser(UserManager userManager){
      user = userManager.user;
      itens.clear();
      if(user != null){
        _carregaCarrinhoItens();
      }
  }

  Future<void>_carregaCarrinhoItens() async {
    final QuerySnapshot carSnap = await user.carrinhoRef.getDocuments();
    itens = carSnap.documents.map((c) => CarrinhoProduto.fromDocumento(c)).toList();
  }

  void addAoCarrinho(Produto produto){
    final carrinhoProduto = CarrinhoProduto.fromProduto(produto);
    itens.add(carrinhoProduto);
    user.carrinhoRef.add(carrinhoProduto.carrinhoItemMap());
  }
}