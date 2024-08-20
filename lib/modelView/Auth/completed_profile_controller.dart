import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meettown/res/global.dart';
import 'package:meettown/view/Auth/SelectPassPort.dart';
import 'package:meettown/view/Auth/Selectlocation.dart';
import 'package:meettown/view/Dashboard/home.dart';

class CompletedProfileController extends ChangeNotifier {
  late File _image;
  var loading = false;
  File get image => _image;

  void setImage(File image) {
    _image = image;
    notifyListeners();
  }

  setLoading(val){
    loading=val;
    notifyListeners();

  }


  setLatLong(context,lat,long) async {
   
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
    var res = await  databaseReference.child('users').child(UserId).update({
       "Latitude":lat,
       "Longitude":long
      });
      

      Get.snackbar("Success", "Location Store Successfully");
    Navigator.push(context,MaterialPageRoute(builder: (context) => PassportPage()));


  }

  storeOtherInfoDb(context,language,profession,nationalalty,relationship,education) async {
     DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      setLoading(true);

    var res = await  databaseReference.child('users').child(UserId).update({
 "langauge" : language,
 "profession":profession,
 "nationalalty":nationalalty,
 "relationship":relationship,
 "education":education
      });
         setLoading(false);

       
      Get.snackbar("Success", "Update Profile  Successfully");
   
    // Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard()));
    Get.offAll(Dashboard());

  }

  StoreImageDb(context,_image) async {
    var res = await uploadFile(_image);
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
       databaseReference.child('users').child(UserId).update({
        "Image": res,
      });
      Get.snackbar("Success", "Store Image Successfully");
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => SetLoctationScreen()));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<String> uploadFile(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('uploads/${file.path}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
