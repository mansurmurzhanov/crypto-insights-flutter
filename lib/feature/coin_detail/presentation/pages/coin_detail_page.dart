import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../bloc/coin_detail_bloc.dart';
import '../bloc/coin_detail_event.dart';
import '../bloc/coin_detail_state.dart';

import '../bloc/coin_chart_bloc.dart';
import '../bloc/coin_chart_event.dart';
import '../bloc/coin_chart_state.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../../l10n/app_localizations.dart';

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
        title: Text(
          AppLocalizations.of(context)!.coinDetails,
        ),
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
                              '${coin.name} ${AppLocalizations.of(context)!.addedToFavorites}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: Text(
                        AppLocalizations.of(context)!.addToFavorites,
                      ),
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
                            return Center(
                              child: Text(
                                AppLocalizations.of(context)!.failedToLoadChart,
                              ),
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
                    Text('${AppLocalizations.of(context)!.price}: ${coin.currentPrice}'),
                    Text('${AppLocalizations.of(context)!.marketCap}: ${coin.marketCap}'),
                    Text('${AppLocalizations.of(context)!.volume}: ${coin.volume}'),
                    Text('${AppLocalizations.of(context)!.rank}: ${coin.marketCapRank}'),
                    Text('${AppLocalizations.of(context)!.ath}: ${coin.ath}'),
                    Text('${AppLocalizations.of(context)!.atl}: ${coin.atl}'),
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