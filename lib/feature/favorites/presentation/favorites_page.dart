import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Favorites Page'),
      ),
    );
  }
}