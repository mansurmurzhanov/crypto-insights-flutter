import 'package:intl/intl.dart';

extension CurrencyFormatting on double {
  String formattedCurrency() {
    return NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '\$',
      decimalDigits: 2,
    ).format(this);
  }
}