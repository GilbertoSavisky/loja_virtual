import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtualgigabyte/models/carrinho_produto.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:lojavirtualgigabyte/models/produto.dart';
import 'package:lojavirtualgigabyte/models/user.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:lojavirtualgigabyte/services/cep_aberto_service.dart';

class CarrinhoManager extends ChangeNotifier {

  List<CarrinhoProduto> itens = [];

  User user;
  Endereco endereco;
  num precoProdutos = 0.0;
  num precoEntraga;
  num get totalPreco => (precoEntraga ?? 0) + precoProdutos;

  bool _loading = false;

  bool get loading => _loading;
  set loading(bool valor) {
    _loading = valor;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager){
      user = userManager.user;
      removeEndereco();
      precoProdutos = 0.0;
      itens.clear();
      if(user != null){
        _carregarCarrinhoItens();
        _carregarUserEndereco();
      }
  }

  Future<void>_carregarCarrinhoItens() async {
    final QuerySnapshot carSnap = await user.carrinhoRef.getDocuments();
    itens = carSnap.documents.map((c) => CarrinhoProduto.fromDocumento(c)..addListener(_onItemUpdate)).toList();
  }

  Future<void> _carregarUserEndereco() async {
    if(user.endereco != null && await calcularEntrega(user.endereco.latitude, user.endereco.longitude))
      endereco = user.endereco;
    notifyListeners();
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

  bool get isEnderecoValido => endereco != null && precoEntraga != null;

  // Endereço
  void getEndereco(String cep) async {
    loading = true;

    final cepAbertoService = CepAbertoService();
    try {
      final cepAberto = await cepAbertoService.getEnderecoFromCep(cep);
      if(cepAberto != null){
        endereco = Endereco(
          rua: cepAberto.logradouro,
          bairro: cepAberto.bairro,
          CEP: cepAberto.cep,
          cidade: cepAberto.cidade.nome,
          estado: cepAberto.estado.sigla,
          latitude: cepAberto.latitude,
          longitude: cepAberto.longitude
        );
      }
      loading = false;
    } catch(e){
      loading = false;
      return Future.error('CEP Inválido!');
    }
  }

  Future<void> setEndereco(Endereco endereco) async {
    loading = true;

    this.endereco = endereco;
    if(await calcularEntrega(endereco.latitude, endereco.longitude)){
      user.setEndereco(endereco);
      loading = false;
    }
    else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  void removeEndereco(){
    endereco = null;
    precoEntraga = null;
    notifyListeners();
  }

  Future<bool> calcularEntrega(double lat, double long) async {
     final DocumentSnapshot doc = await firestore.document('aux/entrega').get();
     final latloja = doc.data['lat'] as double;
     final longloja = doc.data['long'] as double;
     final maxkm = doc.data['maxkm'] as num;
     final base = doc.data['base'] as num;
     final km = doc.data['km'] as num;
     double dist = await Geolocator().distanceBetween(latloja, longloja, lat, long);
     dist /= 1000.0;

     if(dist > maxkm)
       return false;
     precoEntraga = base + dist * km;

     return true;
  }
}