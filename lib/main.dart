import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider_start/core/data_sources/posts/posts_local_data_source.dart';
import 'package:provider_start/core/data_sources/users/users_local_data_source.dart';
import 'package:provider_start/core/localization/localization.dart';
import 'package:provider_start/core/managers/core_manager.dart';
import 'package:provider_start/core/services/hardware_info/hardware_info_service.dart';
import 'package:provider_start/core/utils/logger.dart';
import 'package:provider_start/locator.dart';
import 'package:provider_start/provider_setup.dart';
import 'package:provider_start/ui/router.dart';
import 'package:provider_start/ui/shared/themes.dart' as themes;
import 'package:provider_start/local_setup.dart';
import 'package:provider_start/ui/views/start_up_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogger();
  await setupLocator();

  final postsLocalDataSource = locator<PostsLocalDataSource>();
  final usersLocalDataSource = locator<UsersLocalDataSource>();
  final hardwareInfoService = locator<HardwareInfoService>();

  await Future.wait([
    postsLocalDataSource.init(),
    usersLocalDataSource.init(),
    hardwareInfoService.init(),
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: CoreManager(
        child: PlatformApp(
          android: (_) => MaterialAppData(
            theme: themes.primaryMaterialTheme,
            darkTheme: themes.darkMaterialTheme,
          ),
          ios: (_) => CupertinoAppData(
            theme: themes.primaryCupertinoTheme,
          ),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          localeResolutionCallback: loadSupportedLocals,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          navigatorKey: Get.key,
          onGenerateRoute: Router.generateRoute,
          home: StartUpView(),
        ),
      ),
    );
  }
}
