import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/favorites/bloc/favorites_bloc.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_event.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_state.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorite_coin_details_cubit.dart';
import 'package:crypto_insights/feature/favorites/presentation/favorites_page.dart';
import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_detail_entity.dart';
import 'package:crypto_insights/l10n/app_localizations.dart';

class MockFavoritesBloc
    extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

class MockFavoriteCoinDetailsCubit extends Mock
    implements FavoriteCoinDetailsCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      RemoveFavorite('fallback'),
    );
  });

  late MockFavoritesBloc favoritesBloc;
  late MockFavoriteCoinDetailsCubit detailsCubit;

  const bitcoin = CoinDetailEntity(
    id: 'btc',
    name: 'Bitcoin',
    symbol: 'btc',
    image: 'https://example.com/btc.png',
    currentPrice: 100000,
    marketCap: 1,
    volume: 1,
    marketCapRank: 1,
    ath: 1,
    atl: 1,
  );

  setUp(() {
    favoritesBloc = MockFavoritesBloc();
    detailsCubit = MockFavoriteCoinDetailsCubit();
  });

  Widget buildPage() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesBloc>.value(value: favoritesBloc),
      ],
      child: RepositoryProvider<FavoriteCoinDetailsCubit>.value(
        value: detailsCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FavoritesPage(),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator', (tester) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(status: FavoritesStatus.loading),
    );

    await tester.pumpWidget(buildPage());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message', (tester) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.failure,
        error: 'error',
      ),
    );

    await tester.pumpWidget(buildPage());

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('shows empty state', (tester) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.success,
        favorites: [],
      ),
    );

    await tester.pumpWidget(buildPage());

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('shows favorite coin', (tester) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.success,
        favorites: ['btc'],
      ),
    );

    when(
      () => detailsCubit.getCoinDetail('btc'),
    ).thenAnswer((_) async => bitcoin);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();
    });

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('shows unknown error when error is null', (tester) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.failure,
      ),
    );

    await tester.pumpWidget(buildPage());

    expect(find.text('Unknown error'), findsOneWidget);
  });

  testWidgets('remove favorite dispatches RemoveFavorite', (
    tester,
  ) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.success,
        favorites: ['btc'],
      ),
    );

    when(
      () => detailsCubit.getCoinDetail('btc'),
    ).thenAnswer((_) async => bitcoin);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();
    });

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    final captured = verify(
      () => favoritesBloc.add(captureAny()),
    ).captured;

    expect(
      captured.first,
      isA<RemoveFavorite>(),
    );
  });

  testWidgets('shows snackbar after remove favorite', (
    tester,
  ) async {
    when(() => favoritesBloc.state).thenReturn(
      const FavoritesState(
        status: FavoritesStatus.success,
        favorites: ['btc'],
      ),
    );

    whenListen(
      favoritesBloc,
      const Stream<FavoritesState>.empty(),
      initialState: const FavoritesState(
        status: FavoritesStatus.success,
        favorites: ['btc'],
      ),
    );

    when(
      () => detailsCubit.getCoinDetail('btc'),
    ).thenAnswer((_) async => bitcoin);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();
    });

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
