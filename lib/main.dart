import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/my_theme.dart';
import '/core/routes/routes_names.dart';
import 'dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await DependencyInjector.initDB();
  runApp(const SellerApp());
}

class SellerApp extends StatelessWidget {
  const SellerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: DependencyInjector.repositoryProvider,
      child: MultiBlocProvider(
        providers: DependencyInjector.blocProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteNames.generateRoute,
          initialRoute: RouteNames.animatedSplashScreen ,
          theme: MyCustomTheme.theme,
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('No hay ruta definida para $settings')),
              ),
            );
          },
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
