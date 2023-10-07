import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/routes/routes_names.dart';
import '/modules/on_boarding/component/custom_dot_indicaor.dart';
import '/modules/on_boarding/controller/setting_cubit.dart';
import '/modules/on_boarding/model/on_boarding_model.dart';
import '/utils/constants.dart';
import '/utils/language_string.dart';
import '/widgets/custom_image.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late int _totalPage;
  int _currentPage = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _totalPage = onBoardingList.length;
    _controller = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(_currentPage);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              buildSizedBox(size),
              const SizedBox(height: 25.0),
              getContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getContent() {
    final items = onBoardingList[_currentPage];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            items.name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 36.0,
              color: blackColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            items.subtitle,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              color: grayColor,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 15.0),
          dotIndicator(),
        ],
      ),
    );
  }

  Widget dotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DotIndicatorWidget(currentIndex: _currentPage, dotNumber: _totalPage),
        TextButton(
          onPressed: () {
            if(_currentPage == _totalPage -1){
              context.read<SettingCubit>().cacheOnBoarding();
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.loginScreen, (route) => false);
              return;
            }
            _controller.nextPage(
                duration: const Duration(microseconds: 500),
                curve: Curves.easeInOut);
          },
          style: TextButton.styleFrom(
          foregroundColor: Colors.white, shape: const CircleBorder(),
            minimumSize: const Size(60, 60),
            backgroundColor: primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_forward,
                size: 40.0,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          )
        )
      ],
    );
  }

  Widget buildSizedBox(Size size) {
    return SizedBox(
      height: size.height * 0.6,
      width: size.width,
      // color: Colors.red,
      child: PageView.builder(
        itemCount: _totalPage,
        controller: _controller,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (int p) => setState(() => _currentPage = p),
        itemBuilder: (context, index) {
          return CustomImage(
              path: onBoardingList[index].image, fit: BoxFit.contain);
        },
      ),
    );
  }
}
