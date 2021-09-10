import 'package:get/get.dart';
import 'package:learn_firebase/controllers/crud_controller.dart';

class CrudBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthController>(() => AuthController());
    Get.put<CrudController>(CrudController());
  }
}
