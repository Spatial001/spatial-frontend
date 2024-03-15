import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../constants/globals.dart';
import '../constants/uiColors.dart';
import '../models/create_post.dart';
import '../services/api_services.dart';
import '../widgets/button_login.dart';

// ignore: must_be_immutable
class CreatePostPage extends StatefulWidget {
  TextEditingController titleController = TextEditingController();
  String _imageFile = '';
  String apiresult = '';
  final ImagePicker _picker = ImagePicker();
  CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create Post"),
          backgroundColor: Pallete.whiteColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  // keyboardType: TextInputType.emailAddress,
                  controller: widget.titleController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      hintText: 'Enter Title'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                  onTap: pickImage,
                  buttonText:
                      widget._imageFile == '' ? 'Image' : 'Change Image'),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: widget._imageFile == '' ? false : true,
                child: SizedBox(
                  height: 80,
                  child: Image.memory(
                      const Base64Decoder().convert(widget._imageFile)),
                ),
              ),
              MyButton(onTap: createPostApiCall, buttonText: 'Create'),
              const SizedBox(height: 20),
              Visibility(
                visible: widget.apiresult == '' ? false : true,
                child: Text(widget.apiresult),
              )
            ],
          ),
        ));
  }

  createPostApiCall() async {
    CreatePost postBody = CreatePost(
        title: widget.titleController.text,
        coords: locateCoord!.isEmpty ? [28.6538201, 77.158083] : locateCoord,
        image: widget._imageFile);
    var apiresponse = await createPost(postBody);
    if (apiresponse?.statusCode == 200) {
      // var data = jsonDecode(apiresponse!.body);
      setState(() {
        widget.apiresult = 'Post Created Successfully';
        widget._imageFile = '';
        widget.titleController = TextEditingController();
      });
    } else {
      var error = jsonDecode(apiresponse!.body);
      setState(() {
        widget.apiresult = error['message'];
      });
    }
  }

  pickImage() async {
    try {
      final XFile? image =
          await widget._picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      Uint8List imagebytes = await image.readAsBytes();
      String base64String = base64.encode(imagebytes);
      setState(() {
        widget._imageFile =
            base64String; // setState to image the UI and show picked image on screen.
      });
    } on PlatformException {
      if (kDebugMode) {
        print('error');
      }
    }
  }
}
