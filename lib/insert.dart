import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';
import 'main.dart';

class ccreate extends StatefulWidget {
  @override
  State<ccreate> createState() => ccreateState();
}

class ccreateState extends State<ccreate> {
  TextEditingController name = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;

  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('contacts');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm sản phẩm',
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
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: name,
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
                controller: category,
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
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Giá',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: true, // Không cho phép người dùng nhập liệu trực tiếp
                onTap: () {
                  getImage(); // Mở thư viện ảnh khi nhấn vào trường
                },
                decoration: InputDecoration(
                  hintText: 'Chọn ảnh từ thư viện', // Gợi ý cho người dùng
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.photo, // Biểu tượng thư viện ảnh
                    color: Colors.indigo[900],
                  ),
                  suffixIcon: file != null
                      ? Image.file(
                    file!,
                    width: 50, // Hiển thị ảnh đã chọn
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : null, // Không hiển thị gì nếu chưa có ảnh
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: 40,
                onPressed: () {
                  if (file != null) {
                    uploadFile();
                  }
                },
                child: Text(
                  "Thêm sản phẩm ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
                color: Colors.indigo[500],
              ),
            ],
          ),
        ),
      ),
    )
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${name.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        Map<String, String> Contact = {
          'name': name.text,
          'category': category.text,
          'price': price.text,
          'url': url,
        };

        dbRef!.push().set(Contact).whenComplete(() {
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
}
