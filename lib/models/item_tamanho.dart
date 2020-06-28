class ItemTamanho{
  String nome;
  num preco;
  int estoque;

  ItemTamanho({this.nome, this.preco, this.estoque});

  ItemTamanho.fromMap(Map<String, dynamic> map){
    nome = map['nome'] as String;
    preco = map['preco'] as num;
    estoque = map['estoque'] as int;
  }

  bool get temEstoque => estoque > 0;

  ItemTamanho clone(){
    return ItemTamanho(
      nome: nome,
      estoque: estoque,
      preco: preco,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'preco': preco,
      'estoque': estoque
    };
  }

  @override
  String toString() {
    return 'ItemTamanho{nome: $nome, preco: $preco, estoque: $estoque}';
  }
}