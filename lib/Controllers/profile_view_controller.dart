import 'package:get/get.dart';
import 'package:tnt/Config/app_config.dart';
import '../Models/profile_model.dart';
import '../Services/auth_service.dart';

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
    isLoading.value = true;
    errorMessage.value = '';
    try {
      profile.value = await AuthService.fetchProfile(AppSession.userId ?? 0);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
