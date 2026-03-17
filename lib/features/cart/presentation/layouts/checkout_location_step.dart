import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_labeled_text_field.dart';
import '../../../../shared/widgets/app_selectable_card.dart';
import '../../data/models/warehouse_model.dart';
import '../../data/mocks/mock_warehouses.dart';

const _tashkentCenter = Point(latitude: 41.2995, longitude: 69.2401);

/// Шаг выбора локации доставки или склада
class CheckoutLocationStep extends StatelessWidget {
  final bool isDelivery;
  final Point? selectedDeliveryPoint;
  final WarehouseModel? selectedWarehouse;
  final YandexMapController? mapController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final TextEditingController apartmentController;
  final TextEditingController phoneController;
  final ValueChanged<Point> onMapTap;
  final void Function(YandexMapController) onMapCreated;
  final ValueChanged<WarehouseModel> onWarehouseSelected;
  final VoidCallback onChanged;

  const CheckoutLocationStep({
    super.key,
    required this.isDelivery,
    required this.selectedDeliveryPoint,
    required this.selectedWarehouse,
    required this.mapController,
    required this.cityController,
    required this.streetController,
    required this.apartmentController,
    required this.phoneController,
    required this.onMapTap,
    required this.onMapCreated,
    required this.onWarehouseSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isDelivery ? _DeliveryAddressLayout(
      selectedPoint: selectedDeliveryPoint,
      mapController: mapController,
      cityController: cityController,
      streetController: streetController,
      apartmentController: apartmentController,
      phoneController: phoneController,
      onMapTap: onMapTap,
      onMapCreated: onMapCreated,
      onChanged: onChanged,
    ) : _PickupLayout(
      selectedWarehouse: selectedWarehouse,
      mapController: mapController,
      onWarehouseSelected: onWarehouseSelected,
      onMapCreated: onMapCreated,
    );
  }
}

class _DeliveryAddressLayout extends StatelessWidget {
  final Point? selectedPoint;
  final YandexMapController? mapController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final TextEditingController apartmentController;
  final TextEditingController phoneController;
  final ValueChanged<Point> onMapTap;
  final void Function(YandexMapController) onMapCreated;
  final VoidCallback onChanged;

  const _DeliveryAddressLayout({
    required this.selectedPoint,
    required this.mapController,
    required this.cityController,
    required this.streetController,
    required this.apartmentController,
    required this.phoneController,
    required this.onMapTap,
    required this.onMapCreated,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;
    final mapObjects = <MapObject>[];
    if (selectedPoint != null) {
      mapObjects.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('delivery_point'),
          point: selectedPoint!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.selectPointOnMap,
          style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: YandexMap(
              onMapCreated: (c) {
                c.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _tashkentCenter, zoom: 12),
                  ),
                );
                onMapCreated(c);
              },
              onMapTap: onMapTap,
              mapObjects: mapObjects,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          tr.deliveryAddress,
          style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.base),
        AppLabeledTextField(
          controller: cityController,
          label: tr.city,
          hint: tr.tashkent,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.base),
        AppLabeledTextField(
          controller: streetController,
          label: tr.streetHouse,
          hint: tr.streetHint,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.base),
        AppLabeledTextField(
          controller: apartmentController,
          label: tr.apartment,
          hint: tr.optional,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.base),
        AppLabeledTextField(
          controller: phoneController,
          label: tr.phone,
          hint: '+998 00 000 00 00',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _PickupLayout extends StatelessWidget {
  final WarehouseModel? selectedWarehouse;
  final YandexMapController? mapController;
  final ValueChanged<WarehouseModel> onWarehouseSelected;
  final void Function(YandexMapController) onMapCreated;

  const _PickupLayout({
    required this.selectedWarehouse,
    required this.mapController,
    required this.onWarehouseSelected,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;
    final warehouses = MockWarehouses.warehouses;
    final mapObjects = warehouses
        .map<MapObject>(
          (w) => PlacemarkMapObject(
            mapId: MapObjectId('wh_${w.id}'),
            point: Point(latitude: w.latitude, longitude: w.longitude),
            onTap: (placemark, point) {
              onWarehouseSelected(w);
              mapController?.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: Point(latitude: w.latitude, longitude: w.longitude),
                    zoom: 15,
                  ),
                ),
              );
            },
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.selectWarehouse,
          style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: YandexMap(
              onMapCreated: (c) {
                c.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _tashkentCenter, zoom: 11),
                  ),
                );
                onMapCreated(c);
              },
              mapObjects: mapObjects,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...warehouses.map((w) {
          final isSelected = selectedWarehouse?.id == w.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppSelectableCard(
              isSelected: isSelected,
              title: w.name,
              subtitle: '${w.address}${w.workingHours != null ? '\n${w.workingHours}' : ''}',
              icon: Icons.warehouse_rounded,
              onTap: () {
                onWarehouseSelected(w);
                mapController?.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(latitude: w.latitude, longitude: w.longitude),
                      zoom: 15,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
