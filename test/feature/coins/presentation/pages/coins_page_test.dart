import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auto_route/auto_route.dart';

import 'package:crypto_insights/feature/coins/bloc/coins_bloc.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_event.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_state.dart';
import 'package:crypto_insights/feature/coins/presentation/pages/coins_page.dart';
import 'package:crypto_insights/l10n/app_localizations.dart';
import 'package:crypto_insights/core/error/failure.dart';
import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';

class MockCoinsBloc extends MockBloc<CoinsEvent, CoinsState>
    implements CoinsBloc {}

class FakePageRouteInfo extends Fake implements PageRouteInfo<dynamic> {}

class MockStackRouter extends Mock implements StackRouter {}


void main() {
  setUpAll(() {
    registerFallbackValue(LoadCoins());
    registerFallbackValue(SearchCoins(''));
    registerFallbackValue(SortCoins('marketCap'));
    registerFallbackValue(LoadMoreCoins());
    registerFallbackValue(FakePageRouteInfo());
  });

  late MockCoinsBloc bloc;
  late MockStackRouter router;

  setUp(() {
    bloc = MockCoinsBloc();
    router = MockStackRouter();
    when(() => router.push<Object?>(any())).thenAnswer((_) async => null);
  });

  testWidgets(
    'CoinsPage shows loading state',
    (tester) async {
      const loadingState = CoinsState(
        status: CoinsStatus.loading,
      );

      when(() => bloc.state).thenReturn(
        loadingState,
      );

      whenListen(
        bloc,
        Stream.value(
          loadingState,
        ),
        initialState: loadingState,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      expect(
        find.byType(ListView),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'CoinsPage shows success state',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        coins: [
          CoinEntity(
            id: 'btc',
            symbol: 'btc',
            name: 'Bitcoin',
            image: '',
            currentPrice: 100000,
            priceChange24h: 5,
            marketCapRank: 1,
          ),
        ],
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Bitcoin'), findsOneWidget);
    },
  );

  testWidgets(
    'CoinsPage shows failure state',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.failure,
        error: NetworkFailure('No internet'),
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    },
  );

  testWidgets(
    'CoinsPage retry button dispatches LoadCoins',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.failure,
        error: NetworkFailure('No internet'),
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final captured = verify(
        () => bloc.add(captureAny()),
      ).captured;

      expect(captured.first, isA<LoadCoins>());
    },
  );

  testWidgets(
    'CoinsPage search dispatches SearchCoins',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        coins: [
          CoinEntity(
            id: 'btc',
            symbol: 'btc',
            name: 'Bitcoin',
            image: '',
            currentPrice: 100000,
            priceChange24h: 5,
            marketCapRank: 1,
          ),
        ],
      );

      when(() => bloc.state).thenReturn(state);
      when(() => bloc.stream).thenAnswer(
        (_) => Stream<CoinsState>.value(state),
      );

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'bit',
      );

      final captured = verify(
        () => bloc.add(captureAny()),
      ).captured;

      expect(captured.last, isA<SearchCoins>());
      expect(
        (captured.last as SearchCoins).query,
        'bit',
      );
    },
  );

  testWidgets(
    'CoinsPage shows empty list',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        coins: [],
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    },
  );

  testWidgets(
  'CoinsPage opens sort menu',
  (tester) async {
    const state = CoinsState(
      status: CoinsStatus.success,
      coins: [],
    );

    when(() => bloc.state).thenReturn(state);

    whenListen(
      bloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates:
            AppLocalizations.localizationsDelegates,
        supportedLocales:
            AppLocalizations.supportedLocales,
        home: BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: const CoinsPage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();

    expect(find.byType(PopupMenuItem<String>), findsWidgets);
  },
);

  testWidgets(
    'CoinsPage dispatches SortCoins from popup menu',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        coins: [],
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuItem<String>).first);
      await tester.pumpAndSettle();

      final captured = verify(
        () => bloc.add(captureAny()),
      ).captured;

      expect(
        captured.any((e) => e is SortCoins),
        isTrue,
      );
    },
  );

  testWidgets(
    'CoinsPage opens favorites page',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        coins: [],
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: StackRouterScope(
            controller: router,
            stateHash: 0,
            child: BlocProvider<CoinsBloc>.value(
              value: bloc,
              child: const CoinsPage(),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('favorites_button')));
      await tester.pump();

      verify(() => router.push<Object?>(any())).called(1);
    },
  );

  testWidgets(
    'CoinsPage opens settings page',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        coins: [],
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: StackRouterScope(
            controller: router,
            stateHash: 0,
            child: BlocProvider<CoinsBloc>.value(
              value: bloc,
              child: const CoinsPage(),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('settings_button')));
      await tester.pump();

      verify(() => router.push<Object?>(any())).called(1);
    },
  );

  testWidgets(
    'CoinsPage shows generic failure message',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.failure,
        error: ServerFailure('error'),
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
    },
  );

  testWidgets(
    'CoinsPage filters by symbol',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.success,
        query: 'btc',
        coins: [
          CoinEntity(
            id: 'btc',
            symbol: 'btc',
            name: 'Bitcoin',
            image: '',
            currentPrice: 100000,
            priceChange24h: 5,
            marketCapRank: 1,
          ),
        ],
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales:
              AppLocalizations.supportedLocales,
          home: BlocProvider<CoinsBloc>.value(
            value: bloc,
            child: const CoinsPage(),
          ),
        ),
      );

      expect(find.text('Bitcoin'), findsOneWidget);
    },
  );
}