import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

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
        title: const Text('Crypto Insights'),
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
              return ListView.builder(
                itemCount: state.coins.length,
                itemBuilder: (context, index) {
                  final coin = state.coins[index];

                  return ListTile(
                    leading: Image.network(
                      coin.image,
                      width: 40,
                      height: 40,
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
              );
          }
        },
      ),
    );
  }
}