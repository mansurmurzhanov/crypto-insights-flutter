import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/favorites/bloc/favorites_bloc.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_event.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorites_state.dart';
import 'package:crypto_insights/feature/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:crypto_insights/feature/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:crypto_insights/feature/favorites/domain/usecases/remove_favorite_use_case.dart';

class MockGetFavoritesUseCase extends Mock
    implements GetFavoritesUseCase {}

class MockAddFavoriteUseCase extends Mock
    implements AddFavoriteUseCase {}

class MockRemoveFavoriteUseCase extends Mock
    implements RemoveFavoriteUseCase {}

void main() {
  late MockGetFavoritesUseCase getFavoritesUseCase;
  late MockAddFavoriteUseCase addFavoriteUseCase;
  late MockRemoveFavoriteUseCase removeFavoriteUseCase;

  setUp(() {
    getFavoritesUseCase = MockGetFavoritesUseCase();
    addFavoriteUseCase = MockAddFavoriteUseCase();
    removeFavoriteUseCase = MockRemoveFavoriteUseCase();
  });

  blocTest<FavoritesBloc, FavoritesState>(
    'emits loading then success when favorites load successfully',
    build: () {
      when(
        () => getFavoritesUseCase(),
      ).thenAnswer((_) async => []);

      return FavoritesBloc(
        getFavoritesUseCase,
        addFavoriteUseCase,
        removeFavoriteUseCase,
      );
    },
    act: (bloc) => bloc.add(LoadFavorites()),
    expect: () => [
      isA<FavoritesState>().having(
        (state) => state.status,
        'status',
        FavoritesStatus.loading,
      ),
      isA<FavoritesState>().having(
        (state) => state.status,
        'status',
        FavoritesStatus.success,
      ),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'emits loading then failure when favorites load fails',
    build: () {
      when(
        () => getFavoritesUseCase(),
      ).thenThrow(Exception('error'));

      return FavoritesBloc(
        getFavoritesUseCase,
        addFavoriteUseCase,
        removeFavoriteUseCase,
      );
    },
    act: (bloc) => bloc.add(LoadFavorites()),
    expect: () => [
      isA<FavoritesState>().having(
        (state) => state.status,
        'status',
        FavoritesStatus.loading,
      ),
      isA<FavoritesState>().having(
        (state) => state.status,
        'status',
        FavoritesStatus.failure,
      ),
    ],
  );
}