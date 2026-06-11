// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get hello => 'Привет';

  @override
  String get settings => 'Настройки';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get favorites => 'Избранное';

  @override
  String get noFavorites => 'Нет избранных монет';

  @override
  String get searchCoin => 'Поиск монеты...';

  @override
  String get noFavoritesYet => 'Пока нет избранных';

  @override
  String get addCoinsFromDetails => 'Добавьте монеты со страницы деталей';

  @override
  String get removedFromFavorites => 'удалён из избранного';

  @override
  String get cryptoInsights => 'Крипто Инсайты';

  @override
  String get coinDetails => 'Детали монеты';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get price => 'Цена';

  @override
  String get marketCap => 'Рыночная капитализация';

  @override
  String get volume => 'Объём';

  @override
  String get rank => 'Рейтинг';

  @override
  String get ath => 'Исторический максимум';

  @override
  String get addedToFavorites => 'добавлен в избранное';

  @override
  String get atl => 'Исторический минимум';

  @override
  String get failedToLoadChart => 'Не удалось загрузить график';

  @override
  String get retry => 'Повторить';

  @override
  String get noInternetConnection => 'Нет подключения к интернету';

  @override
  String get checkNetworkAndTryAgain =>
      'Проверьте подключение к сети и попробуйте снова.';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get noCoinsFound => 'Монеты не найдены';

  @override
  String get sortByMarketCap => 'По капитализации';

  @override
  String get topGainers24h => 'Лидеры роста (24ч)';

  @override
  String get topLosers24h => 'Лидеры падения (24ч)';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';
}
