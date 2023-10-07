// "is_featured": "1",
// "new_product": "0",
// "is_top": "0",
// "is_best": "1",
// "status": "1",

import 'package:flutter/material.dart';

import 'constants.dart';

class AllStatusCode {
  static String isStatus(String code) {
    switch (code) {
      case '0':
        return '';
      case '1':
        return 'Activo';
      default:
        return 'Sin texto';
    }
  }

  static String isFeature(String code) {
    switch (code) {
      case '0':
        return '';
      case '1':
        return 'Destacado';
      default:
        return 'Sin texto';
    }
  }

  static String isTop(String code) {
    switch (code) {
      case '0':
        return '';
      case '1':
        return 'Top';
      default:
        return 'Sin texto';
    }
  }

  static String isBest(String code) {
    switch (code) {
      case '0':
        return '';
      case '1':
        return 'Bueno';
      default:
        return 'Sin texto';
    }
  }

  static String isNew(String code) {
    switch (code) {
      case '0':
        return '';
      case '1':
        return 'Nuevo';
      default:
        return 'Sin texto';
    }
  }

  static String getOrderStatus(int code) {
    switch (code + 1) {
      case 1:
        return 'En Progreso';
      case 2:
        return 'Entregado';
      case 3:
        return 'Completado';
      case 4:
        return 'Rechazado';
      default:
        return 'Pendiente';
    }
  }

  static String getPaymentStatus(int code) {
    switch (code + 1) {
      case 1:
        return 'Realizado';
      default:
        return 'Pendiente';
    }
  }

  static String getCategoryText(int code) {
    switch (code) {
      case 1:
        return "Electronics";
      case 2:
        return "Game";
      case 3:
        return "Mobile";
      case 4:
        return "Life Style";
      case 5:
        return "Babies & Toys";
      case 6:
        return "Bike";
      case 7:
        return "Men's Fasion";
      case 8:
        return "Woman Fasion";
      case 9:
        return "Talevision";
      case 10:
        return "Accessories";
      case 11:
        return "John Doe";
      default:
        return "No Category Found";
    }
  }

  static Color getTextColor(String code) {
    switch (code) {
      case '0':
        return redColor;
      case '1':
        return greenColor;
      default:
        return Colors.transparent;
    }
  }

  static Color getBackgroundColor(String code) {
    switch (code) {
      case '0':
        return const Color(0xFFFAD6D7);
      case '1':
        return const Color.fromRGBO(39, 174, 96, 0.16);
      default:
        return Colors.transparent;
    }
  }
}
