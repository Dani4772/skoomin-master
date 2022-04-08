import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/base/themes.dart';
import 'package:skoomin/src/ui/modals/dialog.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  final Map<String, String> images = {};

  ImageSelector({Key? key}) : super(key: key);

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  @override
  Widget build(context) => Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: 150,
          color: Colors.grey.shade200,
          child: widget.images.isEmpty
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.image),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                    ),
                    Text(
                      "No Images Selected!",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: widget.images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => GestureDetector(
                    onLongPress: () {
                      getDialogModal(
                        context: context,
                        child: AlertDialog(
                          title: const Text("Delete image?"),
                          actions: [
                            TextButtonWidget(
                              onPressed: () => setState(() {
                                widget.images
                                    .remove(widget.images.keys.elementAt(i));
                                AppNavigation.pop(context);
                              }),
                              title: "Yes",
                            ),
                            TextButtonWidget(
                              onPressed: () => AppNavigation.pop(context),
                              title: "No",
                            )
                          ],
                        ),
                      );
                    },
                    child: Image.file(
                      File(widget.images.values.elementAt(i)),
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
        ),

        //

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _getButton(
                icon: CupertinoIcons.camera,
                color: AppTheme.primaryColor,
                onPressed: () async {
                  XFile? pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1800,
                    maxHeight: 1800,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      widget.images[DateTime.now().toString()] =
                          pickedFile.path;
                    });
                  } else {
                    debugPrint('No Image Selected');
                  }
                },
              ),
              _getButton(
                color: Colors.orangeAccent,
                icon: CupertinoIcons.folder,
                onPressed: () async {
                  FilePickerResult? tempImages;
                  try {
                    tempImages = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: true,
                    );
                    if (tempImages != null && mounted) {
                      Map<String, String> tempJson = {};
                      for (String? i in tempImages.paths) {
                        tempJson[DateTime.now().toString()] = i ?? '';
                      }
                      setState(() => widget.images.addAll(tempJson));
                    } else {
                      debugPrint('No Image Selected');
                    }
                  } on PlatformException catch (e) {
                    debugPrint('Exception - ${e.toString()}');
                  }
                },
              ),
            ]),
          ),
        ),
      ]);

  Widget _getButton({
    required Color color,
    required IconData icon,
    required Function() onPressed,
  }) =>
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      );
}
