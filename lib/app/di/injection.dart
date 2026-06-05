import 'package:get_it/get_it.dart';

import '../../core/network/dio_client.dart';
import '../../feature/coins/bloc/coins_bloc.dart';
import '../../feature/coins/data/datasource/coins_remote_data_source.dart';
import '../../feature/coins/data/datasource/coins_remote_data_source_impl.dart';
import '../../feature/coins/data/repositories/coins_repository_impl.dart';
import '../../feature/coins/domain/repositories/coins_repository.dart';
import '../../feature/coins/domain/usecases/get_coins_use_case.dart';

import '../../feature/coin_detail/data/datasources/coin_detail_remote_data_source.dart';
import '../../feature/coin_detail/data/repositories/coin_detail_repository_impl.dart';
import '../../feature/coin_detail/domain/repositories/coin_detail_repository.dart';
import '../../feature/coin_detail/domain/usecases/get_coin_detail_use_case.dart';
import '../../feature/coin_detail/presentation/bloc/coin_detail_bloc.dart';

import '../../feature/coin_detail/data/datasources/coin_chart_remote_data_source.dart';
import '../../feature/coin_detail/data/repositories/coin_chart_repository_impl.dart';
import '../../feature/coin_detail/domain/repositories/coin_chart_repository.dart';
import '../../feature/coin_detail/domain/usecases/get_coin_chart_use_case.dart';
import '../../feature/coin_detail/presentation/chart/coin_chart_bloc.dart';
import '../../feature/favorites/domain/favorites_repository.dart';
import '../../feature/favorites/data/favorites_repository_impl.dart';
import '../../feature/favorites/domain/usecases/get_favorites_use_case.dart';
import '../../feature/favorites/domain/usecases/add_favorite_use_case.dart';
import '../../feature/favorites/domain/usecases/remove_favorite_use_case.dart';
import '../../feature/favorites/bloc/favorites_bloc.dart';

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

  getIt.registerLazySingleton<CoinDetailRemoteDataSource>(
    () => CoinDetailRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  getIt.registerLazySingleton<CoinDetailRepository>(
    () => CoinDetailRepositoryImpl(
      getIt<CoinDetailRemoteDataSource>(),
    ),
  );

  getIt.registerFactory(
    () => GetCoinDetailUseCase(
      getIt<CoinDetailRepository>(),
    ),
  );

  getIt.registerFactory(
    () => CoinDetailBloc(
      getIt<GetCoinDetailUseCase>(),
    ),
  );

  getIt.registerLazySingleton<CoinChartRemoteDataSource>(
    () => CoinChartRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  getIt.registerLazySingleton<CoinChartRepository>(
    () => CoinChartRepositoryImpl(
      getIt<CoinChartRemoteDataSource>(),
    ),
  );

  getIt.registerFactory(
    () => GetCoinChartUseCase(
      getIt<CoinChartRepository>(),
    ),
  );

  getIt.registerFactory(
    () => CoinChartBloc(
      getIt<GetCoinChartUseCase>(),
    ),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(),
  );

  getIt.registerFactory(
    () => GetFavoritesUseCase(
      getIt<FavoritesRepository>(),
    ),
  );

  getIt.registerFactory(
    () => AddFavoriteUseCase(
      getIt<FavoritesRepository>(),
    ),
  );

  getIt.registerFactory(
    () => RemoveFavoriteUseCase(
      getIt<FavoritesRepository>(),
    ),
  );

  getIt.registerFactory(
    () => FavoritesBloc(
      getIt<GetFavoritesUseCase>(),
      getIt<AddFavoriteUseCase>(),
      getIt<RemoveFavoriteUseCase>(),
    ),
  );
  
}