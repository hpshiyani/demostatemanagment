import 'dart:io';
import 'dart:math';

import 'package:demostatemanagment/viewdata.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class storage_firebase extends StatefulWidget {
  const storage_firebase({Key? key}) : super(key: key);

  @override
  _storage_firebaseState createState() => _storage_firebaseState();
}

class _storage_firebaseState extends State<storage_firebase> {
  final ImagePicker _picker = ImagePicker();

  String imagee = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showCupertinoDialog(
                    builder: (context) {
                      return Column(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final XFile? photo = await _picker.pickImage(
                                    source: ImageSource.camera);

                                imagee = photo!.path;
                                setState(() {});
                              },
                              child: Text("camera")),
                          ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                imagee = image!.path;
                                setState(() {});
                              },
                              child: Text("Gallry"))
                        ],
                      );
                    },
                    context: context);
              },
              child: Text("Choose Image")),
          CircleAvatar(
            radius: 30,
            backgroundImage: imagee != ""
                ? FileImage(File(imagee))
                : FileImage(File(imagee)),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: name,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: email,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: number,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                String ename = name.text;
                String eemail = email.text;
                String enumber = number.text;

                int aa = Random().nextInt(1000);

                DateTime dd = DateTime.now();

                String timee =
                    "${dd.day}${dd.month}${dd.year}${dd.hour}${dd.minute}${dd.second}${dd.millisecond}${dd.microsecond}";
                String imagename = "$ename$timee";
                try {
                  Reference reff = FirebaseStorage.instance
                      .ref('HariFlutterStorage/$imagename');
                  await reff.putFile(File(imagee));

                  reff.getDownloadURL().then((value) async {
                    print("===$value");
                    String imageuri = value;

                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("RealtimeData").push();
                    String? id = ref.key;

                    await ref.set({
                      "name": ename,
                      "id": id,
                      "email": eemail,
                      "image": imageuri,
                      "number": enumber
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return viewdata();
                      },
                    ));
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Submitdata"))
        ],
      ),
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
}
