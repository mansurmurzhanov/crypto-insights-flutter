import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../coin_detail/domain/entities/coin_detail_entity.dart';
import '../bloc/favorite_coin_details_cubit.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';
import '../../../app/router/app_router.dart';
import '../../../../core/extensions/currency_extension.dart';
import '../../../../core/theme/app_spacing.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favorites)),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FavoritesStatus.failure) {
            return Center(child: Text(state.error ?? 'Unknown error'));
          }

          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64),
                  SizedBox(height: AppSpacing.md),
                  Text(context.l10n.noFavoritesYet),
                  SizedBox(height: AppSpacing.sm),
                  Text(context.l10n.addCoinsFromDetails),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final coinId = state.favorites[index];

              return FutureBuilder<CoinDetailEntity>(
                future: context.read<FavoriteCoinDetailsCubit>().getCoinDetail(
                  coinId,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(title: Text(context.l10n.loading));
                  }

                  final coin = snapshot.data!;

                  return ListTile(
                    key: Key('favorite_coin_$coinId'),
                    onTap: () {
                      context.router.push(CoinDetailRoute(coinId: coinId));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(coin.image),
                    ),
                    title: Text(coin.name),
                    subtitle: Text(coin.symbol.toUpperCase()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(coin.currentPrice.formattedCurrency()),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            context.read<FavoritesBloc>().add(
                              RemoveFavorite(coinId),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${coin.name} ${context.l10n.removedFromFavorites}',
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
    );
  }
}
