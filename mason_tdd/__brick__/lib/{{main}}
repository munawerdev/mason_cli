import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/theme/theme_data.dart';
import '/injection_container.dart' as di;
import '/injection_container.dart';
import '/data/datasources/theme/theme_data_source.dart';
import '/core/constants/global.dart';
import '/core/show/checker_navigator_observer.dart';
import '/features/splash/splash_initial_params.dart';
import '/features/splash/splash_page.dart';

Future<void> main() async {
//  setCustomSystemUIOverlayStyle();
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: '.env');
  await di.init();
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)  => ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => BlocBuilder(
      bloc: getIt<ThemeDataSources>(),
      builder: (context, state) {
        state as bool;
        return MaterialApp(
          navigatorKey: GlobalConstants.navigatorKey,
                  scaffoldMessengerKey: GlobalConstants.scaffoldMessengerKey,
                  navigatorObservers: [CheckerNavigatorObserver()],
            debugShowCheckedModeBanner: false,
            theme: state ? darkTheme : lightTheme,
        home: SplashPage(cubit: getIt(param1: const SplashInitialParams()))
        );
            }));
}