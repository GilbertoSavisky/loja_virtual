import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';
import 'package:lojavirtualgigabyte/models/user.dart';

class PedidosManager extends ChangeNotifier{

  User user;
  List<Pedido> pedidos = [];
  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateUser(User user){
    this.user = user;
    pedidos.clear();
    _subscription?.cancel();

    if(user != null){
      _listarPedidos();
    }
  }

  void _listarPedidos(){
    _subscription = firestore.collection('pedidos').
      where('user', isEqualTo: user.id).snapshots().listen((event) {
        pedidos.clear();
        for(final documento in event.documents){
          pedidos.add(Pedido.fromDocumento(documento));
        }
        notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}