import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/modules/gallery/model/gallery_model.dart';
import '/utils/loading_widget.dart';
import '/widgets/custom_image.dart';
import '/widgets/primary_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../controller/get_gallery_cubit/get_all_gallery_cubit.dart';
import '../controller/store_gallery_bloc/store_gallery_bloc.dart';
import '../model/store_gallery_state_model.dart';

class UploadGalleryImageDialog extends StatefulWidget {
  const UploadGalleryImageDialog({Key? key, required this.galleryModel})
      : super(key: key);
  final GalleryModel galleryModel;

  @override
  State<UploadGalleryImageDialog> createState() =>
      _UploadGalleryImageDialogState();
}

class _UploadGalleryImageDialogState extends State<UploadGalleryImageDialog> {
  @override
  void initState() {
    super.initState();
    //loadProductId();
  }

  loadProductId() {
    context.read<StoreGalleryBloc>().add(
        StoreGalleryEventProductId(widget.galleryModel.product!.id.toString()));
  }

  final String _class = "UploadGalleryImageDialog";

  @override
  Widget build(BuildContext context) {
    final imageUpload = context.read<StoreGalleryBloc>();
    return BlocListener<StoreGalleryBloc, StoreGalleryStateModel>(
      listener: (_, state) {
        final uploadState = state.galleryState;
        if (uploadState is StoreGalleryLoading) {
          log(uploadState.toString(), name: _class);
        } else if (uploadState is StoreGalleryError) {
          Navigator.of(context).pop();
          Utils.errorSnackBar(context, uploadState.message);
        } else if (uploadState is StoreGalleryLoaded) {
          Navigator.of(context).pop();
          context
              .read<GetAllGalleryCubit>()
              .getAllGalleryImages(widget.galleryModel.product!.id.toString());
          Utils.showSnackBar(context, uploadState.message);
          imageUpload.add(StoreGalleryEventClear());
        }
      },
      child: Dialog(
        child: Container(
          height: 300.0,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<StoreGalleryBloc, StoreGalleryStateModel>(
            builder: (context, state) {
              final uploadImage = state.images.isNotEmpty;
              final capture = state.images;
              print('capturedImage: ${capture.length}');
              List<String> imageList = [];
              print('UploadImage: $uploadImage');
              print('state image: ${state.images.length}');
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            if (capture.isNotEmpty) {
                              capture.clear();
                              print('removed images');
                            }
                          },
                          child: const CustomImage(path: KImages.cancel)),
                    ],
                  ),
                  Container(
                    height: 150.0,
                    margin: const EdgeInsets.only(top: 14.0, bottom: 6.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0XFFEBEBEB),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: uploadImage
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: capture.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 100.0,
                                width: 100.0,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                      color: grayColor.withOpacity(0.5)),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CustomImage(
                                        path: capture[index],
                                        height: 60.0,
                                        width: 60.0,
                                        isFile: uploadImage),
                                    Positioned(
                                        right: -6.0,
                                        top: -6.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              capture.removeAt(index);
                                            });
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: redColor,
                                            radius: 12.0,
                                            child: Icon(
                                              Icons.delete,
                                              size: 16.0,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            })
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomImage(path: KImages.placeHolderImage),
                              const SizedBox(width: 20.0),
                              GestureDetector(
                                onTap: () async {
                                  // final images = await Utils.pickSingleImage();
                                  final images =
                                      await Utils.pickMultipleImage();
                                  imageUpload
                                      .add(StoreGalleryEventImage(images));
                                  // imageList.add(images);
                                  // print('ImageList : ${imageList.length}');
                                  //print('images: ${state.images.length}');
                                },
                                child: const Text(
                                  Language.browseImage,
                                  style: TextStyle(
                                    color: blueColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    decoration: TextDecoration.underline,
                                    decorationColor: blueColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 24.0),
                  // BlocBuilder<StoreGalleryBloc, StoreGalleryStateModel>(
                  //   builder: (context, state) {
                  //     return PrimaryButton(
                  //         text: 'Upload Image',
                  //         onPressed: () {
                  //           imageUpload.add(StoreGalleryEventProductId(
                  //               widget.galleryModel.product!.id.toString()));
                  //           print('PI: ${state.productId}');
                  //           // print(galleryModel.product!.id.toString());
                  //         });
                  //   },
                  // )
                  BlocBuilder<StoreGalleryBloc, StoreGalleryStateModel>(
                    builder: (context, state) {
                      final uploadState = state.galleryState;
                      if (uploadState is StoreGalleryLoading) {
                        return const LoadingWidget();
                      }
                      return PrimaryButton(
                          text: 'Upload Image',
                          onPressed: () {
                            imageUpload.add(StoreGalleryEventProductId(
                                widget.galleryModel.product!.id.toString()));
                            imageUpload.add(StoreGalleryEventSubmit());
                          });
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
