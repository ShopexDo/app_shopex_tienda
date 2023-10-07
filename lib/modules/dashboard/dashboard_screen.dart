import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/routes/routes_names.dart';
import '/modules/store_product/controller/category_brand_cubit/category_brand_cubit.dart';
import '/modules/withdraw/component/withdraw_dialog.dart';
import '/utils/constants.dart';
import '../../core/dummy_data/dummy_data.dart';
import '../../core/remote_urls.dart';
import '../../utils/language_string.dart';
import '../../utils/loading_widget.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_image.dart';
import '../order/controller/orders_cubit/orders_cubit.dart';
import '../order/controller/pending_product/pending_product_cubit.dart';
import '../order/controller/seller_all_orders/seller_order_cubit.dart';
import '../profile/controller/seller_profile_cubit.dart';
import '../withdraw/controller/account_info/account_info_cubit.dart';
import 'controller/dashboard_cubit.dart';
import 'model/dashboard_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().getDashboardData();

    context.read<SellerOrderCubit>().getSellerAllOrders();
    context.read<SellerOrderCubit>().getSellerProgressOrders();
    context.read<SellerOrderCubit>().getSellerPendingOrders();
    context.read<SellerOrderCubit>().getSellerDeliveredOrders();
    context.read<SellerOrderCubit>().getSellerCompletedOrders();
    context.read<SellerOrderCubit>().getSellerDeclinedOrders();

    context.read<CategoryBrandCubit>().getAllCategoryAndBrands();

    context.read<OrdersCubit>().getAllProduct();

    context.read<PendingProductCubit>().getAllPendingProduct();

    context.read<SellerProfileCubit>().getSellerProfile();

    //context.read<SellerProfileCubit>().sellerProfile!.setting;

    context.read<AccountInfoCubit>().getAllMethodList();
    //print('methodList: ${context.read<AccountInfoCubit>().accountInfo}');
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.read<DashboardCubit>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (_, state) {
            if (state is DashboardStateError) {
              if (state.statusCode == 503) {
                Utils.serviceUnAvailable(context, state.message);
              }
            }
          },
          builder: (_, state) {
            if (state is DashboardStateLoading) {
              return const LoadingWidget();
            } else if (state is DashboardStateError) {
              if (state.statusCode == 503) {
                return DashboardLoadedWidget(
                    dashboardModel: dashboard.dashboardModel!);
              }
            } else if (state is DashboardStateLoaded) {
              return DashboardLoadedWidget(
                  dashboardModel: state.dashboardModel);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class DashboardLoadedWidget extends StatelessWidget {
  const DashboardLoadedWidget({Key? key, required this.dashboardModel})
      : super(key: key);
  final DashboardModel dashboardModel;

  @override
  Widget build(BuildContext context) {
    print('earningType: ${dashboardModel.todayEarning.runtimeType}');
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          // title: Text(seller.shopName),
          pinned: false,
          // backgroundColor: Colors.transparent,
          backgroundColor: primaryColor.withOpacity(0.2),

          toolbarHeight: 65.0,
          expandedHeight: 65.0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            // background: CustomImage(
            //   path: RemoteUrls.imageUrl(dashboardModel.seller!.bannerImage),
            //   fit: BoxFit.cover,
            // ),
            titlePadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dashboardModel.seller!.shopName,
                    style: GoogleFonts.inter(
                      color: blackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteNames.sellerProfileScreen);
                    },
                    child: Container(
                      height: 45.0,
                      width: 45.0,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: blackColor,
                      ),
                      child: CustomImage(
                        path: RemoteUrls.imageUrl(dashboardModel.seller!.logo),
                        height: 35.0,
                        width: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                height: 90.0,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Language.currentBalance,
                          style: GoogleFonts.inter(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF001B38).withOpacity(0.7)),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          Utils.formatAmount(
                              context, dashboardModel.todayEarning),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30.0,
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => const WithdrawDialog()),
                      child: Container(
                        height: 40.0,
                        width: 104.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          Language.withdraw,
                          style: GoogleFonts.inter(
                            color: whiteColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
        itemCount(),
        const SliverToBoxAdapter(child: SizedBox(height: 40.0)),
      ],
    );
  }

  Widget itemCount() {
    final List<int> count = [
      dashboardModel.totalPendingOrder,
      dashboardModel.todayTotalOrder,
      dashboardModel.totalCompleteOrder,
      dashboardModel.totalProduct,
      dashboardModel.totalProductSale,
      dashboardModel.totalEarning,
    ];
    return SliverToBoxAdapter(
      child: GridView.builder(
        itemCount: dummyData.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        itemBuilder: (context, index) {
          final data = dummyData[index];
          return Container(
            height: 50.0,
            width: 200.0,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(path: data.image),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    data.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: grayColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  index == 5
                      ? Utils.formatAmount(context, count[index])
                      : count[index].toString().padLeft(2, '0'),
                  style: GoogleFonts.inter(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                ),
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
      ),
    );
  }
}
