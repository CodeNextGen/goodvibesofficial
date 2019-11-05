import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class ProfileImageUpload extends StatefulWidget {
  @override
  _ProfileImageUploadState createState() => _ProfileImageUploadState();
}

class _ProfileImageUploadState extends State<ProfileImageUpload> {
  File _image;
  bool isloading = false;


  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final startupProvider = Provider.of<StartupProvider>(context);

    uploadImage() async {
      setState(() {
        isloading =true;
      });
      Dio dio = Dio();
      FormData formData = new FormData.fromMap(
          {"image":  await MultipartFile.fromFile(_image.path)});
      try{
        await dio.put(
        '$baseUrl/v1/users/update_current_user',
        data: formData,
        options: Options(
          headers: {'UUID': startupProvider.userdata.uid},
        ),
      );
      } on DioError catch(e){
        print(e);
        print(e.message);
        print(e.response);
      }
      Response response = await dio.get(
        '$baseUrl/v1/users/present_user',
        options: Options(
          headers: {'UUID': startupProvider.userdata.uid},
        ),
      );
      print(response.data);
      print(response.data['user_image']);
      // startupProvider.userdata.image = response.data[0]['user_image'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('image', response.data['user_image']);
      await startupProvider.getUserData();

      Navigator.pop(context);
    }

    return Center(
      child: Stack(
              children:[ CupertinoAlertDialog(
          content: Column(
            children: <Widget>[
              _image == null ? Container() : Image.file(_image),
              _image == null
                  ? Container()
                  : OutlineButton.icon(
                      icon: Icon(Icons.done),
                      label: Text('Save'),
                      onPressed:isloading==false? uploadImage:null,
                    ),
            ],
          ),
          title: Text('Please select your image'),
          actions: <Widget>[
            OutlineButton.icon(
              borderSide: BorderSide.none,
              icon: Icon(Icons.camera),
              onPressed: isloading==false? getImageCamera:null,
              label: Text('Camera'),
            ),
            OutlineButton.icon(
              borderSide: BorderSide.none,
              icon: Icon(Icons.image),
              onPressed: isloading==false? getImageGallery:null,
              label: Text('Gallery'),
            ),
          ],
        ),
        Center(child: isloading==true? CupertinoActivityIndicator():Container())
              ]
      ),
    );
  }
}
