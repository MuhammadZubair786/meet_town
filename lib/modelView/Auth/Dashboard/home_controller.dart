import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meettown/res/global.dart';

class HomeController extends GetxController {
  File? imageFile;
  var loading = false;
  var _currentAddress;
  var postData =[];
  var userPostUpdate=[];
  final TextEditingController postController = TextEditingController();

  setLoading(val) {
    loading = val;
    update();
  }

  setPost(val,postUser){
    userPostUpdate=postUser;
    postData=val;
        update();

  }

  Future<void> getPostWithEarliestTimestamp() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("posts");

  DataSnapshot snapshot = await ref.get();
  if (snapshot.value != null) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    List<dynamic> values = data.values.toList();
    print(values);
    var postUserSet = <String>{}; // Set to store user IDs
  var postUserList = []; // List to store filtered posts

  for (var i = 0; i < values.length; i++) {
    if (!postUserSet.contains(values[i]['userId'])) {
      postUserSet.add(values[i]['userId']); // Add userId to the set
      postUserList.add(values[i]); // Add post to the list
    }
  }
    print(postUserList);

    setPost(values,postUserList);

  } else {
    print('No data available.');
  }
    // setPost(event.value);
  }

  Future<void> uploadPost(context, String text, File? imageFile) async {
    var res = await getCurrentLocation();
    Navigator.of(context).pop();

    String imageUrl = '';
    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('posts');
    var ref = databaseReference.push();
    await ref.set({
      "userId": UserId,
      "username": UserName,
      'text': text,
      'postImage': imageUrl,
      "userImage": image,
      "address": "USA",
      'timestamp': DateTime.now().toIso8601String(),
      "like": 0,
      "comments": 0,
      "postId": ref.key
    });

    // DatabaseReference databaseReference1 = FirebaseDatabase.instance.ref("users").child('posts');
    // await databaseReference1.push().set({
    //    "userId":UserId,
    //   "username":"name",
    //   "address":"USA",
    //   'text': text,
    //   'imageUrl': imageUrl,
    //   'timestamp': DateTime.now().toIso8601String(),
    //   "like":0,
    //   "comments":0
    // });
    Get.snackbar(
      "Success",
      "Post created successfully", // Display the error message
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
    );
    setLoading(false);
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      _currentAddress = "${place.locality}, ${place.country}";
          update();
      return _currentAddress;
    } catch (e) {
      print(e);
    }
  }



  Future<void> showUploadDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Post'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: postController,
                  decoration: InputDecoration(hintText: 'Share your moment...'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      imageFile = File(pickedFile.path);
                          update();

                    }
                  },
                  child: Text('Upload Image'),
                ),
                imageFile != null ? Image.file(imageFile!) : Container(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Post'),
              onPressed: () async {
                if (postController.text.isNotEmpty || imageFile != null) {
                  setLoading(true);
                  await uploadPost(context, postController.text, imageFile);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
