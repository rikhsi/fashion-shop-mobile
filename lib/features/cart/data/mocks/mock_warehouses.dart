import '../models/warehouse_model.dart';

/// Склады в Ташкенте для самовывоза
abstract final class MockWarehouses {
  static const warehouses = <WarehouseModel>[
    WarehouseModel(
      id: 'wh1',
      name: 'Склад Чиланзар',
      address: 'г. Ташкент, ул. Бахористон, 12',
      latitude: 41.2856,
      longitude: 69.1881,
      workingHours: 'Пн-Вс 9:00–20:00',
    ),
    WarehouseModel(
      id: 'wh2',
      name: 'Склад Юнусабад',
      address: 'г. Ташкент, пр. Амира Темура, 108',
      latitude: 41.3274,
      longitude: 69.2952,
      workingHours: 'Пн-Вс 8:00–22:00',
    ),
    WarehouseModel(
      id: 'wh3',
      name: 'Склад Сергели',
      address: 'г. Ташкент, ул. Сергели-8, 15',
      latitude: 41.2222,
      longitude: 69.2215,
      workingHours: 'Пн-Сб 9:00–19:00',
    ),
  ];
}
