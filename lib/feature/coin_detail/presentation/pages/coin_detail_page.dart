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
import '../../../favorites/bloc/favorites_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/extensions/currency_extension.dart';

@RoutePage()
class CoinDetailPage extends StatelessWidget {
  final String coinId;

  const CoinDetailPage({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
          create: (_) => getIt<FavoritesBloc>()
            ..add(
              LoadFavorites(),
            ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.coinDetails,
          ),
          actions: [
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, favoritesState) {
                final isFavorite =
                    favoritesState.favorites.contains(coinId);

                return IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    if (isFavorite) {
                      context.read<FavoritesBloc>().add(
                            RemoveFavorite(coinId),
                          );
                    } else {
                      context.read<FavoritesBloc>().add(
                            AddFavorite(coinId),
                          );
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
                    Container(
                      height: 32,
                      width: 180,
                      color: AppColors.skeleton,
                    ),
                    const SizedBox(height: AppSpacing.md2),
                    Container(
                      height: 16,
                      width: 80,
                      color: AppColors.skeleton,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      height: 48,
                      color: AppColors.skeleton,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      height: 40,
                      color: AppColors.skeleton,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      height: 200,
                      color: AppColors.skeleton,
                    ),
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
                    const Icon(
                      Icons.wifi_off,
                      size: 48,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.errorMessage == 'noInternetConnection'
                          ? AppLocalizations.of(context)!.noInternetConnection
                          : AppLocalizations.of(context)!.somethingWentWrong,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppLocalizations.of(context)!.checkNetworkAndTryAgain,
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
                      label: Text(
                        AppLocalizations.of(context)!.retry,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.status == CoinDetailStatus.success &&
                state.coin != null) {
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
                                      ChangeChartPeriod(
                                        coinId: coinId,
                                        days: 1,
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(width: AppSpacing.sm),
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
                            const SizedBox(width: AppSpacing.sm),
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
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '${AppLocalizations.of(context)!.price}: ${coin.currentPrice.formattedCurrency()}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.marketCap}: ${coin.marketCap.formattedCurrency()}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.volume}: ${coin.volume.formattedCurrency()}',
                    ),
                    Text('${AppLocalizations.of(context)!.rank}: ${coin.marketCapRank}'),
                    Text(
                      '${AppLocalizations.of(context)!.ath}: ${coin.ath.formattedCurrency()}',
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.atl}: ${coin.atl.formattedCurrency()}',
                    ),
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