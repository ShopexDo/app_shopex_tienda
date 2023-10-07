import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utils/errors_model.dart';
import '../data_sources/remote_data_sources.dart';
import 'exception.dart';

class NetworkParser {
  static const _className = 'RemoteDataSourceImpl';

  static Future<dynamic> callClientWithCatchException(
      CallClientMethod callClientMethod) async {
    try {
      final response = await callClientMethod();
      log(response.statusCode.toString(), name: _className);
      log(response.body, name: _className);
      return _responseParser(response);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('Sin conexión a Internet', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormatException('Excepción de formato de datos', 422);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Se agotó el tiempo de espera', 408);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Servicio no disponible', 503);
    }
  }

  static _responseParser(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        final errorMsg = parsingDoseNotExist(response.body);
        throw BadRequestException(errorMsg, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 401);
      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Solicitud no encontrada', 404);
      case 405:
        throw const UnauthorisedException('Método no permitido', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Se agotó el tiempo de espera', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormatException('Excepción de formato de datos');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        print("errorMsg");
        print(errorMsg.toString());
        throw InvalidInputException(Errors.fromMap(errorMsg), 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Error Interno del Servidor', 500);

      default:
        throw FetchDataException(
            'Se produce un error durante la comunicación con el servidor.', response.statusCode);
    }
  }

  static parsingError(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['errors'] != null) {
        final errors = errorsMap['errors'] as Map;
        return errors;
        // final firstErrorMsg = errors.values.first;
        // if (firstErrorMsg is List) return firstErrorMsg.first;
        // return firstErrorMsg.toString();
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }

    return 'Error desconocido';
  }

  static String parsingDoseNotExist(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['notification'] != null) {
        return errorsMap['notification'];
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }
    return 'Las credenciales no coinciden';
  }
}
