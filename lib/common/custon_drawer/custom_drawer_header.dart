import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/page_manager.dart';
import 'package:lojavirtualgigabyte/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround  ,
            children: [
              Text('Loja de \nPeças Íntimas', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),),
              Text('Olá ${userManager.user?.nome ?? ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(userManager.isLoggedin){
                    context.read<PageManager>().setPage(0);
                    userManager.signOut();
                  } else {
                    Navigator.of(context).pushNamed('/login');
                  }
                },
                child: Text(userManager.isLoggedin ? 'Sair' : 'Entre ou cadastre-se >',
                  style: TextStyle(color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
