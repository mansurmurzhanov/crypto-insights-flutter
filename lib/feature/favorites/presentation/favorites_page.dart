import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../coin_detail/domain/entities/coin_detail_entity.dart';
import '../../coin_detail/domain/usecases/get_coin_detail_use_case.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';
import '../../../app/router/app_router.dart';

@RoutePage()

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favorites,
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<FavoritesBloc>()
          ..add(
            LoadFavorites(),
          ),
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == FavoritesStatus.failure) {
              return Center(
                child: Text(
                  state.error ?? 'Unknown error',
                ),
              );
            }

            if (state.favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noFavoritesYet,
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.addCoinsFromDetails,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final coinId = state.favorites[index];

                return FutureBuilder<CoinDetailEntity>(
                  future: getIt<GetCoinDetailUseCase>()(coinId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    }

                    final coin = snapshot.data!;

                    return ListTile(
                      onTap: () {
                        context.router.push(
                          CoinDetailRoute(
                            coinId: coinId,
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(coin.image),
                      ),
                      title: Text(coin.name),
                      subtitle: Text(coin.symbol.toUpperCase()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${coin.currentPrice.toStringAsFixed(2)}',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              context.read<FavoritesBloc>().add(
                                RemoveFavorite(coinId),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${coin.name} ${AppLocalizations.of(context)!.removedFromFavorites}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}