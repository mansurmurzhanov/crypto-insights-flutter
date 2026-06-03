import 'package:auto_route/auto_route.dart';

import '../../feature/coins/presentation/pages/coins_page.dart';
import '../../feature/favorites/presentation/favorites_page.dart';
import '../../feature/settings/presentation/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: CoinsRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: FavoritesRoute.page,
        ),
        AutoRoute(
          page: SettingsRoute.page,
        ),
      ];
}
