sealed class CoinsEvent {}

final class LoadCoins extends CoinsEvent {}

final class RefreshCoins extends CoinsEvent {}

final class SearchCoins extends CoinsEvent {
  final String query;

  SearchCoins(this.query);
}