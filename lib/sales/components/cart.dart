import 'package:intl/intl.dart';

formattedAmount(product, bool wholesale) =>
    NumberFormat.currency(name: 'TZS ').format(wholesale
        ? product['wholesalePrice'] ?? 0
        : product['retailPrice'] ?? 0);
