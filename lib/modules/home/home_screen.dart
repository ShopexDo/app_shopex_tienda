import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/modules/dashboard/dashboard_screen.dart';
import '/modules/my_shop/my_shop_screen.dart';
import '../../utils/constants.dart';
import '../../utils/k_images.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/primary_button.dart';
import '../order/seller_all_order_screen.dart';
import '../withdraw/withdraw_screen.dart';
import 'component/bottom_navigation_bar.dart';
import 'component/main_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = MainController();
  late List<Widget> screenList;

  @override
  void initState() {
    super.initState();
    screenList = [
      const DashboardScreen(),
      const MyShopScreen(),
      const SellerAllOrderScreen(),
      const WithdrawScreen(),
      // const OrderScreen(),
      // Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitDialog(context);
        return true;
      },
      child: Scaffold(
        body: StreamBuilder<int>(
          initialData: 0,
          stream: _homeController.naveListener.stream,
          builder: (context, AsyncSnapshot<int> snapshot) {
            int item = snapshot.data ?? 0;
            return screenList[item];
          },
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }

  exitDialog(BuildContext context) {
    return Utils.showCustomDialog(
      context,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomImage(path: KImages.exitApp),
            const SizedBox(height: 8.0),
            Text(
              'Are you sure',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                color: blackColor,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'You want to Exit?',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: grayColor,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  text: 'Exit',
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  minimumSize: const Size(125.0, 45.0),
                ),
                const SizedBox(width: 12.0),
                PrimaryButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  bgColor: redColor,
                  textColor: whiteColor,
                  minimumSize: const Size(125.0, 45.0),
                ),
              ],
            ),
            const SizedBox(height: 14.0),
          ],
        ),
      ),
    );
  }
}
