import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/core/error/failure.dart';
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
    required CoinDetailState coinState,
    FavoritesState favoritesState = const FavoritesState(),
  }) {
    when(() => coinDetailBloc.state).thenReturn(coinState);
    when(() => favoritesBloc.state).thenReturn(favoritesState);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinDetailBloc>.value(value: coinDetailBloc),
        BlocProvider<FavoritesBloc>.value(value: favoritesBloc),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CoinDetailPage(coinId: 'bitcoin'),
      ),
    );
  }

  group('CoinDetailPage', () {
    testWidgets('renders loading state', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: const CoinDetailState(
            status: CoinDetailStatus.loading,
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders failure state', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: const CoinDetailState(
            status: CoinDetailStatus.failure,
            failure: NetworkFailure('error'),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders success state', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.success,
            points: points,
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text('24H'), findsOneWidget);
      expect(find.text('7D'), findsOneWidget);
      expect(find.text('30D'), findsOneWidget);
    });

    testWidgets('renders coin header', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.success,
            points: points,
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
    });

    testWidgets('changes chart period', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.success,
            points: points,
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('7D'));
      await tester.pump();

      verify(
        () => coinDetailBloc.add(
          any(that: isA<ChangeChartPeriod>()),
        ),
      ).called(1);
    });

    testWidgets('toggles favorite', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.success,
            points: points,
          ),
          favoritesState: const FavoritesState(
            favorites: [],
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      verify(
        () => favoritesBloc.add(
          any(that: isA<AddFavorite>()),
        ),
      ).called(1);
    });

    testWidgets('removes favorite', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.success,
            points: points,
          ),
          favoritesState: const FavoritesState(
            favorites: ['bitcoin'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pump();

      verify(
        () => favoritesBloc.add(
          any(that: isA<RemoveFavorite>()),
        ),
      ).called(1);
    });

    testWidgets('retry dispatches LoadCoinDetail', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: const CoinDetailState(
            status: CoinDetailStatus.failure,
            failure: NetworkFailure('error'),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(
        () => coinDetailBloc.add(
          any(that: isA<LoadCoinDetail>()),
        ),
      ).called(1);
    });

    testWidgets('shows chart loading', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.loading,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows chart failure', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: CoinDetailState(
            status: CoinDetailStatus.success,
            coin: coin,
            chartStatus: CoinChartStatus.failure,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('renders empty widget for initial state', (tester) async {
      await tester.pumpWidget(
        buildPage(
          coinState: const CoinDetailState(),
        ),
      );

      expect(find.byType(ListView), findsNothing);
      expect(find.byIcon(Icons.wifi_off), findsNothing);
      expect(find.text('Bitcoin'), findsNothing);
    });
  });
}