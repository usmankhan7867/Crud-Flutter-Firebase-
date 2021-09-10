// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

FirebaseFirestore firebase = FirebaseFirestore.instance;

class CrudController extends GetxController {
  create(String name, String email) async {
    try {
      await firebase
          .collection('User')
          .doc()
          .set({'name': name, 'email': email});
    } catch (e) {
      print(e);
    }
  }

  update1(String id, String name, String email) async {
    try {
      isUpdate(false);
      await firebase
          .collection('User')
          .doc(id)
          .update({'name': name, 'email': email});
    } catch (e) {
      print(e);
    }
  }

  delete(String id) async {
    try {
      await firebase.collection('User').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  final isUpdate = false.obs; // our observable

  // swap true/false & save it to observable
  // void toggle() => on.value = on.value ? false : true;
}
