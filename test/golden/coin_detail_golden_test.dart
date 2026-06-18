import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_chart_point_entity.dart';
import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_detail_entity.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_bloc.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_event.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_state.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/pages/coin_detail_page.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_bloc.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_event.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_state.dart';
import 'package:crypto_insights/l10n/app_localizations.dart';

class MockCoinDetailBloc
    extends MockBloc<CoinDetailEvent, CoinDetailState>
    implements CoinDetailBloc {}

class MockFavoritesBloc
    extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

class FakeCoinDetailEvent extends Fake implements CoinDetailEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCoinDetailEvent());
    registerFallbackValue(AddFavorite('test'));
  });

  late MockCoinDetailBloc coinDetailBloc;
  late MockFavoritesBloc favoritesBloc;

  const coin = CoinDetailEntity(
    id: 'bitcoin',
    name: 'Bitcoin',
    symbol: 'btc',
    image: '',
    currentPrice: 100000,
    marketCap: 2000000,
    volume: 500000,
    marketCapRank: 1,
    ath: 110000,
    atl: 1,
  );

  final points = [
    CoinChartPointEntity(
      time: DateTime(2024),
      price: 100000,
    ),
  ];

  setUp(() {
    coinDetailBloc = MockCoinDetailBloc();
    favoritesBloc = MockFavoritesBloc();

    whenListen(
      coinDetailBloc,
      const Stream<CoinDetailState>.empty(),
      initialState: const CoinDetailState(),
    );

    whenListen(
      favoritesBloc,
      const Stream<FavoritesState>.empty(),
      initialState: const FavoritesState(),
    );
  });

  Widget buildPage({
    required ThemeData theme,
  }) {
    final state = CoinDetailState(
      status: CoinDetailStatus.success,
      coin: coin,
      chartStatus: CoinChartStatus.success,
      points: points,
    );

    when(() => coinDetailBloc.state).thenReturn(state);
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinDetailBloc>.value(
          value: coinDetailBloc,
        ),
        BlocProvider<FavoritesBloc>.value(
          value: favoritesBloc,
        ),
      ],
      child: MaterialApp(
        theme: theme,
        localizationsDelegates:
            AppLocalizations.localizationsDelegates,
        supportedLocales:
            AppLocalizations.supportedLocales,
        home: const CoinDetailPage(
          coinId: 'bitcoin',
        ),
      ),
    );
  }

  testGoldens(
    'CoinDetail light',
    (tester) async {
      await tester.pumpWidgetBuilder(
        buildPage(
          theme: ThemeData.light(),
        ),
      );

      await tester.pump(
        const Duration(seconds: 1),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coin_detail_light.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinDetail dark',
    (tester) async {
      await tester.pumpWidgetBuilder(
        buildPage(
          theme: ThemeData.dark(),
        ),
      );

      await tester.pump(
        const Duration(seconds: 1),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coin_detail_dark.png',
        ),
      );
    },
  );
}