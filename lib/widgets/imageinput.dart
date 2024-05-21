import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class imageinput extends StatefulWidget {
  imageinput(this.imgbhj, {super.key});
  void Function(File) imgbhj;
  @override
  State<imageinput> createState() => _imageinputState();
}

class _imageinputState extends State<imageinput> {
  File? imgfile;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          foregroundColor: imgfile == null ? null : Colors.grey,
          backgroundImage: imgfile != null ? FileImage(imgfile!) : null,
          child: imgfile == null
              ? Icon(Icons.image)
              : null, // Show an icon if no image is selected),
        ),
        ElevatedButton(
            onPressed: () async {
              ImagePicker imgPick = ImagePicker();
              try {
                final pickedImg = await imgPick.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 200,
                    imageQuality: 50,
                    maxHeight: double.infinity);
                if (pickedImg != null) {
                  setState(() {
                    widget.imgbhj(File(pickedImg.path));
                    imgfile = File(pickedImg.path);
                  });
                }
              } catch (e) {
                // Handle any errors that occur during image picking
                print('Error picking image: $e');
              }
            },
            style: ElevatedButton.styleFrom(
                fixedSize: Size(130, 30),
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer),
            child: const Text(
              'Add a Image',
              style: TextStyle(fontSize: 10),
            )),
      ],
    );
  }
}
