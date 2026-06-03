import 'package:get_it/get_it.dart';

import '../../core/network/dio_client.dart';
import '../../feature/coins/bloc/coins_bloc.dart';
import '../../feature/coins/data/datasource/coins_remote_data_source.dart';
import '../../feature/coins/data/datasource/coins_remote_data_source_impl.dart';
import '../../feature/coins/data/repositories/coins_repository_impl.dart';
import '../../feature/coins/domain/repositories/coins_repository.dart';
import '../../feature/coins/domain/usecases/get_coins_use_case.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton(
    () => DioClient(),
  );

  getIt.registerLazySingleton<CoinsRemoteDataSource>(
    () => CoinsRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  getIt.registerLazySingleton<CoinsRepository>(
    () => CoinsRepositoryImpl(
      getIt<CoinsRemoteDataSource>(),
    ),
  );

  getIt.registerFactory(
    () => GetCoinsUseCase(
      getIt<CoinsRepository>(),
    ),
  );

  getIt.registerFactory(
    () => CoinsBloc(
      getIt<GetCoinsUseCase>(),
    ),
  );
}