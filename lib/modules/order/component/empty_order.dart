import 'package:flutter/material.dart';
import '/utils/constants.dart';
import '/utils/k_images.dart';
import '/widgets/custom_image.dart';

import '../../../utils/language_string.dart';

class EmptyOrderComponent extends StatelessWidget {
  const EmptyOrderComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 150.0),
            CustomImage(path: KImages.emptyOrder),
            SizedBox(height: 10.0),
            Text(
              Language.emptyOrder,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: blackColor),
            )
          ],
        ),
      ),
    );
  }
}
