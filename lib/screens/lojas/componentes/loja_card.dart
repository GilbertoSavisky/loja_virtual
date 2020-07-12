import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lojavirtualgigabyte/common/custom_icon_button.dart';
import 'package:lojavirtualgigabyte/models/loja.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class LojaCard extends StatelessWidget {

  final Loja loja;

  const LojaCard({Key key, this.loja}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    Color colorForStatus(LojaStatus status){
      switch(status){
        case LojaStatus.FECHADA:
          return Colors.red[800];
        case LojaStatus.ABERTA:
          return Colors.green;
        case LojaStatus.FECHANDO:
          return Colors.yellow[600];
        default:
          return Colors.green;
      }
    }

    void showError(){
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Esta função não esta disponível neste dispositivo'),
            backgroundColor: Colors.red[800],
          )
      );
    }

    Future<void> abrirTelefone () async {
      if((await canLaunch('tel: ${loja.telefoneLimpo}'))){
        launch('tel: ${loja.telefoneLimpo}');
      }
      else{
        showError();
      }
    }


    Future<void> abrirMapa() async {
      try {
        final mapas = await MapLauncher.installedMaps;
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for(final mapa in mapas)
                    ListTile(
                      onTap: (){
                        mapa.showMarker(
                            coords: Coords(
                              loja.endereco.latitude, loja.endereco.longitude
                            ),
                            title: loja.nome,
                            description: loja.enderecoTexto,
                        );
                        Navigator.of(context).pop();
                      },
                      title: Text(mapa.mapName),
                      leading: Image(
                        image: mapa.icon,
                        width: 30,
                        height: 30,
                      ),
                    )
                ],
              ),
            );
          },
        );
      } catch(e){
        showError();
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Container(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(loja.imagem,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                    ),
                    child: Text(loja.statusTexto,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colorForStatus(loja.status),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loja.nome, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),),
                      Text(loja.enderecoTexto, overflow: TextOverflow.ellipsis, maxLines: 2,),
                      Text(loja.operandoTExto, style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      iconData: Icons.map,
                      color: primaryColor,
                      onTap: abrirMapa,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      onTap: abrirTelefone,
                      color: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
