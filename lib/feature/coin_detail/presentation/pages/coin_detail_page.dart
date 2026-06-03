import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
      ),
      body: Center(
        child: Text(
          'Coin ID: $coinId',
        ),
      ),
    );
  }
}