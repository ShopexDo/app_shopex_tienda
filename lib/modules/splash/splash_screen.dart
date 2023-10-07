import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_text_reveal/random_text_reveal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/routes/routes_names.dart';
import '/modules/authentication/login/login_bloc/login_bloc.dart';
import '../on_boarding/controller/setting_cubit.dart';
import '/utils/k_images.dart';
import '/widgets/custom_image.dart';

import '../../utils/constants.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    initializeController();
    getSaveData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  Future<void> getSaveData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final email = pref.getString('email') ?? '';
    final password = pref.getString('password') ?? '';
    print('SavedEmail: $email');
    print('SavedPassword: $password');
  }

  initializeController() {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    controller.addListener(() {
      if (mounted) setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginBloc = context.read<LoginBloc>();
    final settingCubit = context.read<SettingCubit>();
    return Scaffold(
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (_, state) {
          if (state is SettingStateLoaded) {
            print('isLoginTrue ${loginBloc.isLoggedIn}');
            if (loginBloc.isLoggedIn) {
              Navigator.pushReplacementNamed(context, RouteNames.homeScreen);
            } else if (settingCubit.showOnBoarding) {
              print('skip onboarding....');
              Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
            } else {
              print('show on boarding');
              Navigator.pushReplacementNamed(
                  context, RouteNames.onBoardingScreen);
            }
          }
        },
        builder: (_, state) {
          if (state is SettingStateError) {
            return Center(child: Text(state.message));
          }
          return buildSizedBox(size, context);
        },
      ),
    );
  }

  SizedBox buildSizedBox(Size size, BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            // left: 0.0,
            // top: -20.0,
            child: CustomImage(
              path: KImages.splashIcon01,
              height: animation.value * 300,
            ),
          ),
          Positioned(
            bottom: 100.0,
            left: 0.0,
            right: 0.0,
            child: CustomImage(
              path: KImages.splashIcon02,
              width: animation.value * 140,
            ),
          ),
          Positioned(
            bottom: 60.0,
            left: MediaQuery.of(context).size.width / 3.5,
            // right: 40.0,
            // alignment: Alignment.bottomCenter,
            child: RandomTextReveal(
              text: 'Shopex Tienda App',
              duration: const Duration(seconds: 3),
              style: GoogleFonts.nunito(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: grayColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
