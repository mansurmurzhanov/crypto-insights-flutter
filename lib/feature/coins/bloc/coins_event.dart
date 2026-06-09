sealed class CoinsEvent {}

final class LoadCoins extends CoinsEvent {}

final class RefreshCoins extends CoinsEvent {}

final class SearchCoins extends CoinsEvent {
  final String query;

  SearchCoins(this.query);
}
final class SortCoins extends CoinsEvent {
  final String sortBy;

  SortCoins(this.sortBy);
}
final class LoadMoreCoins extends CoinsEvent {}