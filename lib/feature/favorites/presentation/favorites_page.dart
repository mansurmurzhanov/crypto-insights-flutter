import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/injection.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

@RoutePage()

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocProvider(
        create: (_) => getIt<FavoritesBloc>()
          ..add(
            LoadFavorites(),
          ),
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == FavoritesStatus.failure) {
              return Center(
                child: Text(
                  state.error ?? 'Unknown error',
                ),
              );
            }

            if (state.favorites.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text('No favorites yet'),
                    SizedBox(height: 8),
                    Text('Add coins from details screen'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final coinId = state.favorites[index];

                return ListTile(
                  title: Text(coinId),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      context.read<FavoritesBloc>().add(
                        RemoveFavorite(coinId),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$coinId removed from favorites',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}