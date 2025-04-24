import 'dart:async';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/utils/Preferences.dart';

class ReferCodeController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;

  @override
  Future<void> onInit() async {
    getUser();
    super.onInit();
  }

  RxBool isLoading = true.obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      isLoading.value = false;
    }
  }
}
