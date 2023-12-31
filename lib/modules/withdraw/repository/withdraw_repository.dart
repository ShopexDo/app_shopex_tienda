import 'package:dartz/dartz.dart';

import '/core/data_sources/remote_data_sources.dart';
import '/core/errors/exception.dart';
import '/core/errors/failure.dart';
import '../controller/create_withdraw/create_withdraw_state_model.dart';
import '../model/account_info_model.dart';
import '../model/withdraw_model.dart';

abstract class WithdrawRepository {
  Future<Either<Failure, AccountInfoModel>> getAccountInformation(
      String id, String token);

  Future<Either<Failure, List<AccountInfoModel>>> getAllMethodList(
      String token);
  Future<Either<Failure, List<WithdrawModel>>> getAllWithdrawList(String token);

  Future<Either<Failure, String>> createWithdrawMethod(
      CreateWithdrawStateModel body, String token);
}

class WithdrawRepositoryImpl implements WithdrawRepository {
  final RemoteDataSources remoteDataSources;

  const WithdrawRepositoryImpl({required this.remoteDataSources});

  @override
  Future<Either<Failure, AccountInfoModel>> getAccountInformation(
      String id, String token) async {
    try {
      final result = await remoteDataSources.getAccountInformation(id, token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> createWithdrawMethod(
      CreateWithdrawStateModel body, String token) async {
    try {
      final result = await remoteDataSources.createWithdrawMethod(body, token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, List<AccountInfoModel>>> getAllMethodList(
      String token) async {
    try {
      final result = await remoteDataSources.getAllMethodList(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<WithdrawModel>>> getAllWithdrawList(
      String token) async {
    try {
      final result = await remoteDataSources.getAllWithdrawList(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
