import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtualgigabyte/models/pedido.dart';
import 'package:lojavirtualgigabyte/models/user.dart';

class AdminPedidosManager extends ChangeNotifier{

  User userFilter;
  List<Status> statusFiltro = [Status.PREPARANDO];

  final List<Pedido> _pedidos = [];
  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateAdmin({bool adminHabilitade}){

    _pedidos.clear();
    _subscription?.cancel();

    if(adminHabilitade){
      _listarPedidos();
    }
  }

  void setStatusFiltro({Status status, bool enabled}){
    if(enabled)
      statusFiltro.add(status);
    else
      statusFiltro.remove(status);
    notifyListeners();
  }

  List<Pedido> get pedidosFiltrados {
    List<Pedido> output = _pedidos.reversed.toList();

    if(userFilter != null){
      output = output.where((pedido) => pedido.userId == userFilter.id).toList();
    }
      output = output.where((pedido) => statusFiltro.contains(pedido.status)).toList();
    return output;
  }

  void _listarPedidos(){
    _subscription = firestore.collection('pedidos').snapshots().listen((event) {
      for(final change in event.documentChanges){
        switch(change.type){
          case DocumentChangeType.added:
            _pedidos.add(Pedido.fromDocumento(change.document));
            break;
          case DocumentChangeType.modified:
            final pedidoModificado = _pedidos.firstWhere((element) => element.orderId == change.document.documentID);
            pedidoModificado.updateFromDocumento(change.document);
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
      notifyListeners();
    });
  }

  void setUserFilter(User user){
    userFilter = user;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}