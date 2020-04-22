import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider_start/core/constant/view_routes.dart';
import 'package:provider_start/core/data_sources/posts/posts_local_data_source.dart';
import 'package:provider_start/core/data_sources/users/users_local_data_source.dart';
import 'package:provider_start/core/services/auth/auth_service.dart';
import 'package:provider_start/core/services/hardware_info/hardware_info_service.dart';
import 'package:provider_start/core/view_models/base_view_model.dart';
import 'package:provider_start/locator.dart';

class StartUpViewModel extends BaseViewModel {
  final _postsLocalDataSource = locator<PostsLocalDataSource>();
  final _usersLocalDataSource = locator<UsersLocalDataSource>();
  final _hardwareInfoService = locator<HardwareInfoService>();
  final _authService = locator<AuthService>();

  Future handleStartUpLogic() async {
    final hasLoggedInUser = await _authService.isUserLoggedIn();

    await Future.wait([
      _postsLocalDataSource.init(),
      _usersLocalDataSource.init(),
      _hardwareInfoService.init(),
    ]);

    if (hasLoggedInUser) {
      unawaited(Get.offNamed(ViewRoutes.main));
    } else {
      unawaited(Get.offNamed(ViewRoutes.login));
    }
  }

  @override
  void dispose() {
    print("i should be disposing");
    super.dispose();
  }
}
