import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lojavirtualgigabyte/models/endereco.dart';
import 'package:screenshot/screenshot.dart';

class ExportEnderecoDialogo extends StatelessWidget {

  final Endereco endereco;

  final ScreenshotController screenshotController = ScreenshotController();

  ExportEnderecoDialogo({Key key, this.endereco}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${endereco.rua} ${endereco.numero} ${endereco.complemento}\n'
            '${endereco.bairro}\n'
            '${endereco.cidade}/${endereco.estado}\n'
                '${endereco.CEP}'
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Exportar'),
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await screenshotController.capture();
            await GallerySaver.saveImage(file.path);
          },
        ),
      ],
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
    );
  }
}
