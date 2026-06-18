import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/core/error/failure.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_bloc.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_event.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_state.dart';
import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/feature/coins/presentation/pages/coins_page.dart';
import 'package:crypto_insights/l10n/app_localizations.dart';

class MockCoinsBloc extends MockBloc<CoinsEvent, CoinsState>
    implements CoinsBloc {}

void main() {
  late MockCoinsBloc bloc;

  setUp(() {
    bloc = MockCoinsBloc();
  });

  testGoldens(
    'CoinsPage golden success state',
    (tester) async {
      final state = CoinsState(
        status: CoinsStatus.success,
        visibleCount: 5,
        coins: List.generate(
          20,
          (i) => CoinEntity(
            id: 'coin$i',
            symbol: 'c$i',
            name: 'Coin $i',
            image: '',
            currentPrice: 1000,
            priceChange24h: 1,
            marketCapRank: i + 1,
          ),
        ),
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_success_light.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinsPage golden initial state',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.initial,
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_initial_light.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinsPage golden loading state',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.loading,
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_loading_light.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinsPage golden failure state',
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

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_failure_light.png',
        ),
      );
    },
  );
  testGoldens(
    'CoinsPage golden success dark state',
    (tester) async {
      final state = CoinsState(
        status: CoinsStatus.success,
        visibleCount: 5,
        coins: List.generate(
          20,
          (i) => CoinEntity(
            id: 'coin$i',
            symbol: 'c$i',
            name: 'Coin $i',
            image: '',
            currentPrice: 1000,
            priceChange24h: 1,
            marketCapRank: i + 1,
          ),
        ),
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            theme: ThemeData.dark(),
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_success_dark.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinsPage golden initial dark state',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.initial,
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            theme: ThemeData.dark(),
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_initial_dark.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinsPage golden loading dark state',
    (tester) async {
      const state = CoinsState(
        status: CoinsStatus.loading,
      );

      when(() => bloc.state).thenReturn(state);

      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            theme: ThemeData.dark(),
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_loading_dark.png',
        ),
      );
    },
  );

  testGoldens(
    'CoinsPage golden failure dark state',
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

      await tester.pumpWidgetBuilder(
        BlocProvider<CoinsBloc>.value(
          value: bloc,
          child: MaterialApp(
            theme: ThemeData.dark(),
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const CoinsPage(),
          ),
        ),
      );

      await tester.pump();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile(
          '../goldens/coins_page_failure_dark.png',
        ),
      );
    },
  );

}