import 'package:flutter/material.dart';
import 'package:lojavirtualgigabyte/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String titulo;
  final int page;

  DrawerTile({this.iconData, this.titulo, this.page});


  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;
    final Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData, size: 32,
                color: curPage == page ? primaryColor : Colors.grey[700],),
            ),
            Text(
              titulo, style: TextStyle(
                color: curPage == page ? primaryColor : Colors.grey[700], fontSize: 16),)
          ],
        ),
      ),
    );
  }
}
