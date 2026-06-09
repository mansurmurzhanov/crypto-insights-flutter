import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/extensions/currency_extension.dart';
import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../domain/entities/coin_entity.dart';

class CoinTile extends StatelessWidget {
  final CoinEntity coin;

  const CoinTile({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context) {
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
        errorWidget: (context, url, error) => const CircleAvatar(
          child: Icon(Icons.currency_bitcoin),
        ),
      ),
      title: Text(coin.name),
      subtitle: Text(
        coin.symbol.toUpperCase(),
      ),
      trailing: Text(
        coin.currentPrice.formattedCurrency(),
      ),
    );
  }
}