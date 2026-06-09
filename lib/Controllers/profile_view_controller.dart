import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tnt/Globle/app_const.dart';
import '../Models/profile_model.dart';

class ProfileViewController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://technewstips.com/api/user/profile'),
      );

      request.fields.addAll({
        'email': AppConst.useremail?? "",                  //'cloud@sg.com'
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);

        if (data['status'] == true && data['user'] != null) {
          profile.value = ProfileModel.fromJson(data['user']);
        } else {
          errorMessage.value = data['message'] ?? 'Unknown error';
        }
      } else {
        errorMessage.value = "Server error: ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }


}
