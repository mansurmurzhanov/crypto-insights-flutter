import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../bloc/coin_detail_bloc.dart';
import '../bloc/coin_detail_event.dart';
import '../bloc/coin_detail_state.dart';

import '../chart/coin_chart_bloc.dart';
import '../chart/coin_chart_event.dart';
import '../chart/coin_chart_state.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';

@RoutePage()
class CoinDetailPage extends StatelessWidget {
  final String coinId;

  const CoinDetailPage({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: null,
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<CoinDetailBloc>()
              ..add(
                LoadCoinDetail(coinId),
              ),
          ),
          BlocProvider(
            create: (_) => getIt<CoinChartBloc>()
              ..add(
                LoadCoinChart(
                  coinId: coinId,
                  days: 1,
                ),
              ),
          ),
          BlocProvider(
            create: (_) => getIt<FavoritesBloc>(),
          ),
        ],
        child: BlocBuilder<CoinDetailBloc, CoinDetailState>(
          builder: (context, state) {
            if (state.status == CoinDetailStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == CoinDetailStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Unknown error',
                ),
              );
            }

            if (state.status == CoinDetailStatus.success &&
                state.coin != null) {
              final coin = state.coin!;
              final favoritesBloc = context.read<FavoritesBloc>();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Text(
                      coin.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(coin.symbol.toUpperCase()),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        favoritesBloc.add(
                          AddFavorite(coin.id),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${coin.name} added to favorites',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Add to Favorites'),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<CoinChartBloc, CoinChartState>(
                      builder: (context, chartState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              label: const Text('24H'),
                              selected: chartState.selectedDays == 1,
                              onSelected: (_) {
                                context.read<CoinChartBloc>().add(
                                  ChangeChartPeriod(
                                    coinId: coinId,
                                    days: 1,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('7D'),
                              selected: chartState.selectedDays == 7,
                              onSelected: (_) {
                                context.read<CoinChartBloc>().add(
                                  ChangeChartPeriod(
                                    coinId: coinId,
                                    days: 7,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('30D'),
                              selected: chartState.selectedDays == 30,
                              onSelected: (_) {
                                context.read<CoinChartBloc>().add(
                                  ChangeChartPeriod(
                                    coinId: coinId,
                                    days: 30,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BlocBuilder<CoinChartBloc, CoinChartState>(
                        builder: (context, chartState) {
                          if (chartState.status == CoinChartStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (chartState.status == CoinChartStatus.failure) {
                            return const Center(
                              child: Text('Failed to load chart'),
                            );
                          }

                          return SfCartesianChart(
                            primaryXAxis: DateTimeAxis(),
                            series: <CartesianSeries>[
                              LineSeries(
                                dataSource: chartState.points,
                                xValueMapper: (point, _) => point.time,
                                yValueMapper: (point, _) => point.price,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Price: ${coin.currentPrice}'),
                    Text('Market Cap: ${coin.marketCap}'),
                    Text('Volume: ${coin.volume}'),
                    Text('Rank: ${coin.marketCapRank}'),
                    Text('ATH: ${coin.ath}'),
                    Text('ATL: ${coin.atl}'),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}