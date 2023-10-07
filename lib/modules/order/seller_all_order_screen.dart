import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/utils/utils.dart';

import '/modules/order/controller/seller_all_orders/seller_order_cubit.dart';
import '/utils/constants.dart';
import '/utils/loading_widget.dart';
import 'component/empty_order.dart';
import 'component/single_order_component.dart';

class SellerAllOrderScreen extends StatelessWidget {
  const SellerAllOrderScreen({Key? key}) : super(key: key);
  final _className = 'SellerAllOrderScreen';

  @override
  Widget build(BuildContext context) {
    context.read<SellerOrderCubit>().getSellerAllOrders();
    context.read<SellerOrderCubit>().getSellerPendingOrders();
    context.read<SellerOrderCubit>().getSellerProgressOrders();
    context.read<SellerOrderCubit>().getSellerDeliveredOrders();
    context.read<SellerOrderCubit>().getSellerCompletedOrders();
    context.read<SellerOrderCubit>().getSellerDeclinedOrders();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Pedidos', style: TextStyle(color: blackColor)),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<SellerOrderCubit, SellerOrderState>(
        listener: (_, state) {
          if (state is SellerOrderStateLoading) {
            log(state.toString(), name: _className);
          }
          if (state is SellerOrderStateLoaded) {
            log(state.toString(), name: _className);
          }
          if (state is SellerOrderStateError) {
            if (state.statusCode == 503) {
              Utils.serviceUnAvailable(context, state.message);
            }
          }
        },
        builder: (_, state) {
          if (state is SellerOrderStateLoading) {
            return const LoadingWidget();
          } else if (state is SellerOrderStateError) {
            if (state.statusCode == 503) {
              return Container();
            } else {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: redColor),
                ),
              );
            }
          } else if (state is SellerOrderStateLoaded) {
            return const SellerOrderLoaded();
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class SellerOrderLoaded extends StatefulWidget {
  const SellerOrderLoaded({Key? key}) : super(key: key);

  @override
  State<SellerOrderLoaded> createState() => _SellerOrderLoadedState();
}

class _SellerOrderLoadedState extends State<SellerOrderLoaded> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sellerOrders = [
      context.read<SellerOrderCubit>().sellerOrders,
      context.read<SellerOrderCubit>().pendingOrders,
      context.read<SellerOrderCubit>().progressOrders,
      context.read<SellerOrderCubit>().deliveredOrders,
      context.read<SellerOrderCubit>().completedOrders,
      context.read<SellerOrderCubit>().declinedOrders,
    ];
    final items = [
      context.read<SellerOrderCubit>().sellerOrders!.orders!.data.length,
      context.read<SellerOrderCubit>().pendingOrders!.orders!.data.length,
      context.read<SellerOrderCubit>().progressOrders!.orders!.data.length,
      context.read<SellerOrderCubit>().deliveredOrders!.orders!.data.length,
      context.read<SellerOrderCubit>().completedOrders!.orders!.data.length,
      context.read<SellerOrderCubit>().declinedOrders!.orders!.data.length,
    ];
    return CustomScrollView(
      slivers: [
        // const SliverAppBar(
        //   expandedHeight: 90.0,
        //   backgroundColor: primaryColor,
        //   // centerTitle: true,
        //   title: Padding(
        //     padding: EdgeInsets.only(top: 30.0),
        //     child: Text(
        //       'Orders',
        //       style: TextStyle(
        //         fontSize: 28.0,
        //         color: blackColor,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       bottomRight: Radius.circular(30.0),
        //     ),
        //   ),
        // ),
        const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: List.generate(sellerOrders.length, (index) {
                  bool active = _currentIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentIndex = index);
                      print(sellerOrders[_currentIndex]);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(microseconds: 800),
                      height: 46.0,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: active ? primaryColor : transparent,
                        border: Border.all(
                            color: active
                                ? primaryColor
                                : const Color(0xFF939DB1)),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '${sellerOrders[index]!.title} (${items[index]})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        items[_currentIndex] == 0
            ? const EmptyOrderComponent()
            : SingleOrderComponent(orders: sellerOrders[_currentIndex]!),
        const SliverToBoxAdapter(child: SizedBox(height: 30.0)),
      ],
    );
  }

  // Padding buildPadding() {
  //   return const Padding(
  //     padding: EdgeInsets.only(top: 20.0),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           backgroundColor: blackColor,
  //           radius: 20.0,
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 8.0),
  //             child: Icon(Icons.arrow_back_ios,
  //                 color: whiteColor, size: 20.0),
  //           ),
  //         ),
  //         SizedBox(width: 15.0),
  //       ],
  //     ),
  //   );
  // }
}
