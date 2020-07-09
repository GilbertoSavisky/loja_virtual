import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/common/custon_drawer/custom_drawer.dart';
import 'package:lojavirtualgigabyte/models/admin_pedidos_manager.dart';
import 'package:lojavirtualgigabyte/models/admin_users_manager.dart';
import 'package:lojavirtualgigabyte/models/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminManager, __){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(adminManager.users[index].nome,
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                subtitle: Text(adminManager.users[index].email,
                  style: TextStyle( color: Colors.white),
                ),
                onTap: (){
                  context.read<AdminPedidosManager>().setUserFilter(adminManager.users[index]);
                  context.read<PageManager>().setPage(5);
                },
              );
            },
            indexedHeight: (index) => 80,
            strList: adminManager.nomes,
            showPreview: true,
            keyboardUsage: true,
            highlightTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          );
        },
      ),
    );
  }
}
