import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/constants.dart';
import '/modules/review/controller/review_cubit.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ReviewCubit>().getAllReviews();
    return Scaffold(
      appBar: AppBar(title: const Text('Review Screen'),backgroundColor: primaryColor),
    );
  }
}
