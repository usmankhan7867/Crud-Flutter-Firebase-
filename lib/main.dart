// import 'package:firebase_core/firebase_core.dart';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase/controllers/bindings/bindings.dart';
import 'package:learn_firebase/controllers/crud_controller.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: CrudBinding(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final controller = CrudController();

  clear() {
    nameController.clear();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),

              Text(
                'Flutter Firebase Crud',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Obx(() => controller.isUpdate.value
                  ? ElevatedButton(
                      onPressed: () {
                        controller.update1(idController.text,
                            nameController.text, emailController.text);
                        clear();
                      },
                      child: Text('update'))
                  : ElevatedButton(
                      onPressed: () {
                        controller.create(
                            nameController.text, emailController.text);
                        clear();
                      },
                      child: Text('create'))),

              FirebaseData(
                  controller: controller,
                  clear: clear(),
                  nameController: nameController,
                  idController: idController,
                  emailController: emailController),
              // Container(
              //   width: double.infinity,
              //   height: 300,
              //   child: SingleChildScrollView(
              //     physics: ScrollPhysics(),
              //     child: StreamBuilder<QuerySnapshot>(
              //       stream: firebase.collection('user').snapshots(),
              //       builder: (context, snapshot) {
              //         if (snapshot.hasData) {
              //           return ListView.builder(itemBuilder: (context, i) {
              //             QueryDocumentSnapshot x = snapshot.data!.docs[i];
              //             return Text(
              //               x['name'],
              //               style: TextStyle(color: Colors.black),
              //             );
              //           });
              //         } else {
              //           return CircularProgressIndicator();
              //         }
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseData extends StatelessWidget {
  // final did;
  // final name;
  // final email;
  final controller;
  final clear;
  final TextEditingController nameController;

  final TextEditingController emailController;
  final TextEditingController idController;

  const FirebaseData(
      {Key? key,
      this.controller,
      this.clear,
      required this.emailController,
      required this.idController,
      required this.nameController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('User').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView(
                children: snapshot.data!.docs
                    .map(
                      (doc) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(doc['name']),
                                    SizedBox(height: 5),
                                    Text(doc['email']),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    nameController.text = doc['name'];
                                    emailController.text = doc['email'];
                                    idController.text = doc.id;
                                    controller.isUpdate(true);
                                    // print(nameController.text);
                                    // controller.update1(doc['id']);
                                    clear();
                                  },
                                  icon: Icon(Icons.update),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.delete(doc.id);
                                    clear();
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),

                            // Text(doc['name']),
                            // Text(doc['email']),

                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    )
                    .toList());
          }
        },
      ),
    );
  }
}
