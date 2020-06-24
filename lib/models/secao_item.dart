class SecaoItem {

  SecaoItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    produto = map['produto'] as String;
  }

  String image;
  String produto;
}
