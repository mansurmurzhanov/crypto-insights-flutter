enum FavoritesStatus {
  initial,
  loading,
  success,
  failure,
}

class FavoritesState {
  final FavoritesStatus status;
  final List<String> favorites;
  final String? error;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.error,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<String>? favorites,
    String? error,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      error: error ?? this.error,
    );
  }
}