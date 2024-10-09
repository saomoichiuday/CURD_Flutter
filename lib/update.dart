import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';
import 'main.dart';

class UpdateRecord extends StatefulWidget {
  String Contact_Key;

  UpdateRecord({required this.Contact_Key});

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  TextEditingController contactName =  TextEditingController();
  TextEditingController contactCategory = new TextEditingController();
  TextEditingController contactPrice = new TextEditingController();
  var url;
  var url1;
  File? file;
  ImagePicker image = ImagePicker();
  DatabaseReference? db_Ref;
//Để đọc hoặc ghi dữ liệu từ cơ sở dữ liệu, bạn cần một phiên bản của DatabaseReference
  @override
  void initState() {
    super.initState();
    db_Ref = FirebaseDatabase.instance.ref().child('contacts');
    Contactt_data();
  }

  void Contactt_data() async {
    DataSnapshot snapshot = await db_Ref!.child(widget.Contact_Key).get();

    Map Contact = snapshot.value as Map;

    setState(() {
      contactName.text = Contact['name'];
      contactCategory.text = Contact['category'];
      contactPrice.text = Contact['price'];
      url = Contact['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cập nhật sản phẩm',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[500],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: url == null
                      ? MaterialButton(
                          height: 100,
                          child: Image.file(
                            file!,
                            fit: BoxFit.fill,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        )
                      : MaterialButton(
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(url),
                              ),
                            ),
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: contactName,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Tên sản phẩm',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: contactCategory,
                // Sử dụng đúng bộ điều khiển cho loại sản phẩm
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Loại sản phẩm',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: contactPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Giá',
                ),
                maxLength: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: 40,
                onPressed: () {
                  if (file != null) {
                    uploadFile();
                  } else {
                    directupdate();
                  }
                },
                child: Text(
                  "Cập nhật sản phẩm ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
                color: Colors.indigo[900],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      url = null;
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${contactName.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url1 = await snapshot.ref.getDownloadURL();
      setState(() {
        url1 = url1;
      });
      if (url1 != null) {
        Map<String, String> Contact = {
          'name': contactName.text,
          'category': contactCategory.text,
          'price': contactPrice.text,
          'url': url1,
        };

        db_Ref!.child(widget.Contact_Key).update(Contact).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Home(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  directupdate() {
    if (url != null) {
      Map<String, String> Contact = {
        'name': contactName.text,
        'category': contactCategory.text,
        'price': contactPrice.text,
        'url': url,
      };

      db_Ref!.child(widget.Contact_Key).update(Contact).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Home(),
          ),
        );
      });
    }
  }
}
