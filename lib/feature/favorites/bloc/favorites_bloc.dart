import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../domain/usecases/add_favorite_use_case.dart';
import '../domain/usecases/get_favorites_use_case.dart';
import '../domain/usecases/remove_favorite_use_case.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  FavoritesBloc(
    this.getFavoritesUseCase,
    this.addFavoriteUseCase,
    this.removeFavoriteUseCase,
  ) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FavoritesStatus.loading,
      ),
    );

    try {
      final favorites = await getFavoritesUseCase();

      emit(
        state.copyWith(
          status: FavoritesStatus.success,
          favorites: favorites,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    await addFavoriteUseCase(event.coinId);

    add(LoadFavorites());
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    await removeFavoriteUseCase(event.coinId);

    add(LoadFavorites());
  }
}