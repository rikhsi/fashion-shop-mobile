/// Модель склада для самовывоза
class WarehouseModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? workingHours;

  const WarehouseModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.workingHours,
  });
}
