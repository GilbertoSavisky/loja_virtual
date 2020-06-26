import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final ImagePicker picker = ImagePicker();

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  @override
  Widget build(BuildContext context) {

    Future<void> imagemSelecionada(File image) async {
      if(image != null) {
        File imagemEditada = await ImageCropper.cropImage(sourcePath: image.path,
            androidUiSettings: AndroidUiSettings(
                toolbarColor: Theme.of(context).primaryColor,
                toolbarTitle: 'Editar Imagem',
                toolbarWidgetColor: Colors.white
            ),
            iosUiSettings: IOSUiSettings(
              title: 'Editar Imagem',
              cancelButtonTitle: 'Cancelar',
              doneButtonTitle: 'Concluir'
            ),
            aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
        if(imagemEditada != null)
          onImageSelected(imagemEditada);
      }
    }

    if(Platform.isAndroid) {
      return BottomSheet(
        onClosing: (){},
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.transparent,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
              child: Text('Câmera'),
              onPressed: () async {
                final PickedFile file = await picker.getImage(source: ImageSource.camera);
                imagemSelecionada(File(file.path));
              },
            ),
            FlatButton(
              child: Text('Galeria'),
              onPressed: () async {
                final PickedFile file = await picker.getImage(source: ImageSource.gallery);
                imagemSelecionada(File(file.path));
              },
            ),
          ],
        ),
      );
    } else
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              final PickedFile file = await picker.getImage(source: ImageSource.camera);
              imagemSelecionada(File(file.path));

            },
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final PickedFile file = await picker.getImage(source: ImageSource.gallery);
              imagemSelecionada(File(file.path));
            },
            child: const Text('Galeria'),
          ),
        ],
      );
  }
}