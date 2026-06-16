import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coins/bloc/coins_bloc.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_event.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_state.dart';
import 'package:crypto_insights/feature/coins/presentation/pages/coins_page.dart';
import 'package:crypto_insights/l10n/app_localizations.dart';
import 'package:crypto_insights/core/error/failure.dart';
import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';

class MockCoinsBloc extends MockBloc<CoinsEvent, CoinsState>
    implements CoinsBloc {}

void main() {
  late MockCoinsBloc bloc;

  setUp(() {
    bloc = MockCoinsBloc();
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
}