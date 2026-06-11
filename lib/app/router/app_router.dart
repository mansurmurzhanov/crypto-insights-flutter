import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/coin_detail/domain/usecases/get_coin_detail_use_case.dart';
import '../../feature/coin_detail/presentation/bloc/coin_chart_bloc.dart';
import '../../feature/coin_detail/presentation/bloc/coin_chart_event.dart';
import '../../feature/coin_detail/presentation/bloc/coin_detail_bloc.dart';
import '../../feature/coin_detail/presentation/bloc/coin_detail_event.dart';
import '../../feature/coins/presentation/pages/coins_page.dart';
import '../../feature/coins/bloc/coins_bloc.dart';
import '../../feature/coins/bloc/coins_event.dart';
import '../../feature/coin_detail/presentation/pages/coin_detail_page.dart';
import '../../feature/favorites/bloc/favorite_coin_details_cubit.dart';
import '../../feature/favorites/bloc/favorites_bloc.dart';
import '../../feature/favorites/bloc/favorites_event.dart';
import '../../feature/favorites/presentation/favorites_page.dart';
import '../../feature/settings/presentation/settings_page.dart';
import '../di/injection.dart';

part 'app_router.gr.dart';

@RoutePage(name: 'CoinsRoute')
class CoinsRoutePage extends StatelessWidget {
  const CoinsRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoinsBloc>()..add(LoadCoins()),
      child: const CoinsPage(),
    );
  }
}

@RoutePage(name: 'FavoritesRoute')
class FavoritesRoutePage extends StatelessWidget {
  const FavoritesRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<FavoritesBloc>()..add(LoadFavorites()),
        ),
        BlocProvider(
          create: (_) =>
              FavoriteCoinDetailsCubit(getIt<GetCoinDetailUseCase>()),
        ),
      ],
      child: const FavoritesPage(),
    );
  }
}

@RoutePage(name: 'CoinDetailRoute')
class CoinDetailRoutePage extends StatelessWidget {
  const CoinDetailRoutePage({super.key, required this.coinId});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CoinDetailBloc>()..add(LoadCoinDetail(coinId)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<CoinChartBloc>()
                ..add(LoadCoinChart(coinId: coinId, days: 1)),
        ),
        BlocProvider(
          create: (_) => getIt<FavoritesBloc>()..add(LoadFavorites()),
        ),
      ],
      child: CoinDetailPage(coinId: coinId),
    );
  }
}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CoinsRoute.page, initial: true),
    AutoRoute(page: FavoritesRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: CoinDetailRoute.page),
  ];
}
