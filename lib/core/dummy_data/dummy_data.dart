import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/utils/k_images.dart';
import '/utils/language_string.dart';

class DummyDashboardModel extends Equatable {
  final String image;
  final String name;

  const DummyDashboardModel({required this.name, required this.image});

  @override
  List<Object?> get props => [
        image,
        name,
      ];
}

final List<DummyDashboardModel> dummyData = [
  const DummyDashboardModel(
    name: Language.pendingOrders,
    image: KImages.pendingOrders,
  ),
  const DummyDashboardModel(
    name: Language.newOrders,
    image: KImages.newOrders,
  ),
  const DummyDashboardModel(
    name: Language.completedOrders,
    image: KImages.completedOrders,
  ),
  const DummyDashboardModel(
    name: Language.totalProducts,
    image: KImages.totalProducts,
  ),
  const DummyDashboardModel(
    name: Language.totalProductSell,
    image: KImages.totalProductSell,
  ),
  const DummyDashboardModel(
    name: Language.totalEarning,
    image: KImages.totalEarning,
  ),
];

class CategoryNameId extends Equatable {
  final int id;
  final String name;

  const CategoryNameId({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

final List<CategoryNameId> categoryId = [
  const CategoryNameId(id: 1, name: 'Electronics'),
  const CategoryNameId(id: 2, name: 'Game'),
  const CategoryNameId(id: 3, name: 'Mobile'),
  const CategoryNameId(id: 4, name: 'Life Style'),
  const CategoryNameId(id: 5, name: 'Babies & Toys'),
  const CategoryNameId(id: 6, name: 'Bike'),
  const CategoryNameId(id: 7, name: "Men's Fasion"),
  const CategoryNameId(id: 8, name: 'Woman Fasion'),
  const CategoryNameId(id: 9, name: 'Talevision'),
  const CategoryNameId(id: 10, name: 'Accessories'),
  const CategoryNameId(id: 11, name: 'John Doe'),
];

class ProductStatusModel extends Equatable {
  final String title;
  final String id;

  const ProductStatusModel({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}

final List<ProductStatusModel> productStatusModel = [
  const ProductStatusModel(id: '1', title: 'Activo'),
  const ProductStatusModel(id: '0', title: 'Inactivo'),
];

final List<Map<String, dynamic>> galleryAndVariant = [
  {
    'title': Language.imageGallery,
    'icon': Icons.image,
    'on_tap': () {
      print('gallery');
    }
  },
  {
    'title': Language.productVariant,
    'icon': Icons.add_a_photo_outlined,
    'on_tap': () {
      print('variant');
    }
  }
];
