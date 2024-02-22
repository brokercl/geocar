import 'package:get/get.dart';

import '../modules/geocar/bindings/geocar_binding.dart';
import '../modules/geocar/views/geocar_view.dart';
import '../modules/invoice/bindings/invoice_binding.dart';
import '../modules/invoice/views/invoice_view.dart';
import '../modules/locate/bindings/locate_binding.dart';
import '../modules/locate/views/locate_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.geocar;

  static final routes = [
    GetPage(
      name: _Paths.geocar,
      page: () => GeoCarView(),
      binding: GeoCarBinding(),
    ),
    GetPage(
      name: _Paths.locate,
      page: () => const LocateView(),
      binding: LocateBinding(),
    ),
    GetPage(
      name: _Paths.invoice,
      page: () => InvoiceView(),
      binding: InvoiceBinding(),
    ),
  ];
}
