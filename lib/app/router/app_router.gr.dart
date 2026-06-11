// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CoinDetailRoutePage]
class CoinDetailRoute extends PageRouteInfo<CoinDetailRouteArgs> {
  CoinDetailRoute({
    Key? key,
    required String coinId,
    List<PageRouteInfo>? children,
  }) : super(
         CoinDetailRoute.name,
         args: CoinDetailRouteArgs(key: key, coinId: coinId),
         initialChildren: children,
       );

  static const String name = 'CoinDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CoinDetailRouteArgs>();
      return CoinDetailRoutePage(key: args.key, coinId: args.coinId);
    },
  );
}

class CoinDetailRouteArgs {
  const CoinDetailRouteArgs({this.key, required this.coinId});

  final Key? key;

  final String coinId;

  @override
  String toString() {
    return 'CoinDetailRouteArgs{key: $key, coinId: $coinId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CoinDetailRouteArgs) return false;
    return key == other.key && coinId == other.coinId;
  }

  @override
  int get hashCode => key.hashCode ^ coinId.hashCode;
}

/// generated route for
/// [CoinsRoutePage]
class CoinsRoute extends PageRouteInfo<void> {
  const CoinsRoute({List<PageRouteInfo>? children})
    : super(CoinsRoute.name, initialChildren: children);

  static const String name = 'CoinsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CoinsRoutePage();
    },
  );
}

/// generated route for
/// [FavoritesRoutePage]
class FavoritesRoute extends PageRouteInfo<void> {
  const FavoritesRoute({List<PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesRoutePage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}
