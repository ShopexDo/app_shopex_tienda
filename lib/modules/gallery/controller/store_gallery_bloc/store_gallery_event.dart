part of 'store_gallery_bloc.dart';

abstract class StoreGalleryEvent extends Equatable {
  const StoreGalleryEvent();

  @override
  List<Object?> get props => [];
}

class StoreGalleryEventImage extends StoreGalleryEvent {
  final List<String> images;

  const StoreGalleryEventImage(this.images);

  @override
  List<Object?> get props => [images];
}

class StoreGalleryEventProductId extends StoreGalleryEvent {
  final String productId;

  const StoreGalleryEventProductId(this.productId);

  @override
  List<Object?> get props => [productId];
}

class StoreGalleryEventSubmit extends StoreGalleryEvent {
  // // final String images;
  // final String productId;
  // const StoreGalleryEventSubmit(this.productId);
  // @override
  // List<Object?> get props => [productId];
}
class StoreGalleryEventClear extends StoreGalleryEvent {}
