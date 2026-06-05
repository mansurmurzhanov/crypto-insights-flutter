import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';

import '../../bloc/coins_bloc.dart';
import '../../bloc/coins_event.dart';
import '../../bloc/coins_state.dart';

@RoutePage()
class CoinsPage extends StatelessWidget {
  const CoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.cryptoInsights,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              context.router.push(
                const FavoritesRoute(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.router.push(
                const SettingsRoute(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CoinsBloc, CoinsState>(
        builder: (context, state) {
          switch (state.status) {
            case CoinsStatus.initial:
              context.read<CoinsBloc>().add(LoadCoins());
              return const Center(
                child: CircularProgressIndicator(),
              );

            case CoinsStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case CoinsStatus.failure:
              return Center(
                child: Text(state.error ?? 'Unknown error'),
              );

            case CoinsStatus.success:
              final query = state.query.toLowerCase().trim();

              final filteredCoins = state.coins.where((coin) {
                return coin.name.toLowerCase().contains(query) ||
                    coin.symbol.toLowerCase().contains(query);
              }).toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchCoin,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<CoinsBloc>().add(
                          SearchCoins(value),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<CoinsBloc>().add(
                          RefreshCoins(),
                        );
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredCoins.length,
                        itemBuilder: (context, index) {
                          final coin = filteredCoins[index];

                          return ListTile(
                            onTap: () {
                              context.router.push(
                                CoinDetailRoute(
                                  coinId: coin.id,
                                ),
                              );
                            },
                            leading: CachedNetworkImage(
                              imageUrl: coin.image,
                              width: 40,
                              height: 40,
                              placeholder: (context, url) => const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                    child: Icon(Icons.currency_bitcoin),
                                  ),
                            ),
                            title: Text(coin.name),
                            subtitle: Text(
                              coin.symbol.toUpperCase(),
                            ),
                            trailing: Text(
                              '\$${coin.currentPrice}',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}