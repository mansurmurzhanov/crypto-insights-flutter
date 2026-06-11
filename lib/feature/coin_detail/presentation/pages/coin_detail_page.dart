import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/coin_detail_bloc.dart';
import '../bloc/coin_detail_event.dart';
import '../bloc/coin_detail_state.dart';

import '../bloc/coin_chart_bloc.dart';
import '../bloc/coin_chart_event.dart';
import '../bloc/coin_chart_state.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../favorites/bloc/favorites_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/extensions/currency_extension.dart';

class CoinDetailPage extends StatelessWidget {
  final String coinId;

  const CoinDetailPage({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.coinDetails),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, favoritesState) {
              final isFavorite = favoritesState.favorites.contains(coinId);

              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  if (isFavorite) {
                    context.read<FavoritesBloc>().add(RemoveFavorite(coinId));
                  } else {
                    context.read<FavoritesBloc>().add(AddFavorite(coinId));
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CoinDetailBloc, CoinDetailState>(
        builder: (context, state) {
          if (state.status == CoinDetailStatus.loading) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ListView(
                children: [
                  Container(height: 32, width: 180, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md2),
                  Container(height: 16, width: 80, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.lg),
                  Container(height: 48, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.lg),
                  Container(height: 40, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md),
                  Container(height: 200, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.lg),
                  Container(height: 16, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md2),
                  Container(height: 16, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md2),
                  Container(height: 16, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md2),
                  Container(height: 16, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md2),
                  Container(height: 16, color: AppColors.skeleton),
                  const SizedBox(height: AppSpacing.md2),
                  Container(height: 16, color: AppColors.skeleton),
                ],
              ),
            );
          }

          if (state.status == CoinDetailStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    state.errorMessage == 'noInternetConnection'
                        ? context.l10n.noInternetConnection
                        : context.l10n.somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.checkNetworkAndTryAgain,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CoinDetailBloc>().add(
                        LoadCoinDetail(coinId),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.status == CoinDetailStatus.success && state.coin != null) {
            final coin = state.coin!;

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ListView(
                children: [
                  Text(
                    coin.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(coin.symbol.toUpperCase()),
                  const SizedBox(height: AppSpacing.md2),

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
                                ChangeChartPeriod(coinId: coinId, days: 1),
                              );
                            },
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ChoiceChip(
                            label: const Text('7D'),
                            selected: chartState.selectedDays == 7,
                            onSelected: (_) {
                              context.read<CoinChartBloc>().add(
                                ChangeChartPeriod(coinId: coinId, days: 7),
                              );
                            },
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ChoiceChip(
                            label: const Text('30D'),
                            selected: chartState.selectedDays == 30,
                            onSelected: (_) {
                              context.read<CoinChartBloc>().add(
                                ChangeChartPeriod(coinId: coinId, days: 30),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                            child: Text(context.l10n.failedToLoadChart),
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
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${context.l10n.price}: ${coin.currentPrice.formattedCurrency()}',
                  ),
                  Text(
                    '${context.l10n.marketCap}: ${coin.marketCap.formattedCurrency()}',
                  ),
                  Text(
                    '${context.l10n.volume}: ${coin.volume.formattedCurrency()}',
                  ),
                  Text('${context.l10n.rank}: ${coin.marketCapRank}'),
                  Text('${context.l10n.ath}: ${coin.ath.formattedCurrency()}'),
                  Text('${context.l10n.atl}: ${coin.atl.formattedCurrency()}'),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
