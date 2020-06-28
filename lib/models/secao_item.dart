class SecaoItem {

  SecaoItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    produto = map['produto'] as String;
  }

  SecaoItem({this.produto, this.image});

  dynamic image;
  String produto;

  SecaoItem clone(){
    return SecaoItem(
      image: image,
      produto: produto
    );
  }
}
