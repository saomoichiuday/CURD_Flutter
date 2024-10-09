import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/update.dart';

import 'insert.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    DatabaseReference db_Ref = FirebaseDatabase.instance.ref().child('contacts');

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo[100],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ccreate(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text(
            'Danh sách sản phẩm',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.indigo[500],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: db_Ref,
                shrinkWrap: true,
                itemBuilder: (context, snapshot, animation, index) {
                  Map Contact = snapshot.value as Map;
                  Contact['key'] = snapshot.key;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateRecord(
                            Contact_Key: Contact['key'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        tileColor: Colors.indigo[100],
                        trailing: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[700],
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  db_Ref.child(Contact['key']).remove();
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.red[700],
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UpdateRecord(
                                        Contact_Key: Contact['key'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        leading: Container(
                          height: 75,
                          width: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(Contact['url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tên sản phẩm: ${Contact['name']}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Loại sản phẩm: ${Contact['category']}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "Giá: ${Contact['price']} VND",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}