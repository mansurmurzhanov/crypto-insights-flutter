// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:crypto_insights/app/bloc/locale/locale_cubit.dart' as _i392;
import 'package:crypto_insights/app/bloc/theme_mode/theme_mode_cubit.dart'
    as _i300;
import 'package:crypto_insights/core/network/dio_client.dart' as _i181;
import 'package:crypto_insights/feature/coin_detail/data/datasources/coin_chart_remote_data_source.dart'
    as _i603;
import 'package:crypto_insights/feature/coin_detail/data/datasources/coin_detail_remote_data_source.dart'
    as _i274;
import 'package:crypto_insights/feature/coin_detail/data/repositories/coin_chart_repository_impl.dart'
    as _i495;
import 'package:crypto_insights/feature/coin_detail/data/repositories/coin_detail_repository_impl.dart'
    as _i606;
import 'package:crypto_insights/feature/coin_detail/domain/repositories/coin_chart_repository.dart'
    as _i100;
import 'package:crypto_insights/feature/coin_detail/domain/repositories/coin_detail_repository.dart'
    as _i782;
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_chart_use_case.dart'
    as _i32;
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_detail_use_case.dart'
    as _i34;
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_chart_bloc.dart'
    as _i607;
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_bloc.dart'
    as _i665;
import 'package:crypto_insights/feature/coins/bloc/coins_bloc.dart' as _i119;
import 'package:crypto_insights/feature/coins/data/datasource/coins_remote_data_source.dart'
    as _i285;
import 'package:crypto_insights/feature/coins/data/datasource/coins_remote_data_source_impl.dart'
    as _i370;
import 'package:crypto_insights/feature/coins/data/repositories/coins_repository_impl.dart'
    as _i670;
import 'package:crypto_insights/feature/coins/domain/repositories/coins_repository.dart'
    as _i559;
import 'package:crypto_insights/feature/coins/domain/usecases/get_coins_use_case.dart'
    as _i391;
import 'package:crypto_insights/feature/favorites/bloc/favorites_bloc.dart'
    as _i98;
import 'package:crypto_insights/feature/favorites/data/favorites_repository_impl.dart'
    as _i565;
import 'package:crypto_insights/feature/favorites/domain/favorites_repository.dart'
    as _i489;
import 'package:crypto_insights/feature/favorites/domain/usecases/add_favorite_use_case.dart'
    as _i523;
import 'package:crypto_insights/feature/favorites/domain/usecases/get_favorites_use_case.dart'
    as _i826;
import 'package:crypto_insights/feature/favorites/domain/usecases/remove_favorite_use_case.dart'
    as _i703;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i392.LocaleCubit>(() => _i392.LocaleCubit());
    gh.factory<_i300.ThemeModeCubit>(() => _i300.ThemeModeCubit());
    gh.lazySingleton<_i181.DioClient>(() => _i181.DioClient());
    gh.lazySingleton<_i489.FavoritesRepository>(
      () => _i565.FavoritesRepositoryImpl(),
    );
    gh.lazySingleton<_i274.CoinDetailRemoteDataSource>(
      () => _i274.CoinDetailRemoteDataSourceImpl(gh<_i181.DioClient>()),
    );
    gh.lazySingleton<_i603.CoinChartRemoteDataSource>(
      () => _i603.CoinChartRemoteDataSourceImpl(gh<_i181.DioClient>()),
    );
    gh.lazySingleton<_i285.CoinsRemoteDataSource>(
      () => _i370.CoinsRemoteDataSourceImpl(gh<_i181.DioClient>()),
    );
    gh.lazySingleton<_i782.CoinDetailRepository>(
      () => _i606.CoinDetailRepositoryImpl(
        gh<_i274.CoinDetailRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i100.CoinChartRepository>(
      () =>
          _i495.CoinChartRepositoryImpl(gh<_i603.CoinChartRemoteDataSource>()),
    );
    gh.factory<_i32.GetCoinChartUseCase>(
      () => _i32.GetCoinChartUseCase(gh<_i100.CoinChartRepository>()),
    );
    gh.factory<_i523.AddFavoriteUseCase>(
      () => _i523.AddFavoriteUseCase(gh<_i489.FavoritesRepository>()),
    );
    gh.factory<_i826.GetFavoritesUseCase>(
      () => _i826.GetFavoritesUseCase(gh<_i489.FavoritesRepository>()),
    );
    gh.factory<_i703.RemoveFavoriteUseCase>(
      () => _i703.RemoveFavoriteUseCase(gh<_i489.FavoritesRepository>()),
    );
    gh.lazySingleton<_i559.CoinsRepository>(
      () => _i670.CoinsRepositoryImpl(gh<_i285.CoinsRemoteDataSource>()),
    );
    gh.factory<_i34.GetCoinDetailUseCase>(
      () => _i34.GetCoinDetailUseCase(gh<_i782.CoinDetailRepository>()),
    );
    gh.factory<_i98.FavoritesBloc>(
      () => _i98.FavoritesBloc(
        gh<_i826.GetFavoritesUseCase>(),
        gh<_i523.AddFavoriteUseCase>(),
        gh<_i703.RemoveFavoriteUseCase>(),
      ),
    );
    gh.factory<_i391.GetCoinsUseCase>(
      () => _i391.GetCoinsUseCase(gh<_i559.CoinsRepository>()),
    );
    gh.factory<_i119.CoinsBloc>(
      () => _i119.CoinsBloc(gh<_i391.GetCoinsUseCase>()),
    );
    gh.factory<_i607.CoinChartBloc>(
      () => _i607.CoinChartBloc(gh<_i32.GetCoinChartUseCase>()),
    );
    gh.factory<_i665.CoinDetailBloc>(
      () => _i665.CoinDetailBloc(gh<_i34.GetCoinDetailUseCase>()),
    );
    return this;
  }
}
