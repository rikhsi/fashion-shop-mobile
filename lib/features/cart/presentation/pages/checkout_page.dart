import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../profile/data/mocks/mock_profile_data.dart';
import '../../../profile/data/models/order_model.dart';
import '../../data/cart_service.dart';
import '../../data/models/warehouse_model.dart';
import '../layouts/checkout_confirm_step.dart';
import '../layouts/checkout_delivery_type_step.dart';
import '../layouts/checkout_location_step.dart';
import '../layouts/checkout_payment_step.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _cart = sl<CartService>();
  int _step = 0;
  bool _placing = false;

  // Шаг 0: доставка или самовывоз
  DeliveryType _deliveryType = DeliveryType.delivery;

  // Шаг 1: локация
  YandexMapController? _mapController;
  Point? _selectedDeliveryPoint;
  WarehouseModel? _selectedWarehouse;

  // Delivery
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _phoneController = TextEditingController();

  // Payment
  PaymentMethod _paymentMethod = PaymentMethod.payme;

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _apartmentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _canProceedDelivery {
    return _cityController.text.trim().isNotEmpty &&
        _streetController.text.trim().isNotEmpty &&
        _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '').length >= 9;
  }

  static const _totalSteps = 4;

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      _placeOrder();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  void _placeOrder() {
    setState(() => _placing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final items = _cart.items
          .map(
            (i) => OrderItemModel(
              title: i.product.title,
              imageUrl: i.product.imageUrl,
              price: i.product.price,
              quantity: i.quantity,
            ),
          )
          .toList();
      final orderNumber = 'FS-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}${(MockProfileData.orders.length + 1).toString().padLeft(3, '0')}';
      final deliveryAddr = _deliveryType == DeliveryType.delivery
          ? DeliveryAddressModel(
              city: _cityController.text.trim(),
              street: _streetController.text.trim(),
              apartment: _apartmentController.text.trim().isNotEmpty
                  ? _apartmentController.text.trim()
                  : null,
              phone: _phoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
              latitude: _selectedDeliveryPoint?.latitude,
              longitude: _selectedDeliveryPoint?.longitude,
            )
          : null;
      final warehouseId = _deliveryType == DeliveryType.pickup
          ? _selectedWarehouse?.id
          : null;

      MockProfileData.orders.insert(
        0,
        OrderModel(
          id: 'o_new_${DateTime.now().millisecondsSinceEpoch}',
          orderNumber: orderNumber,
          date: DateTime.now(),
          status: OrderStatus.pending,
          total: _cart.totalPrice,
          itemCount: _cart.itemCount,
          items: items,
          paymentMethod: _paymentMethod,
          deliveryType: _deliveryType,
          deliveryAddress: deliveryAddr,
          warehouseId: warehouseId,
        ),
      );
      _cart.clear();
      setState(() => _placing = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.tr.orderPlacedSuccess),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      context.go('/profile/orders');
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          _step == 0
              ? tr.delivery
              : _step == 1
                  ? (_deliveryType == DeliveryType.delivery ? tr.deliveryAddress : tr.selectWarehouse)
                  : _step == 2
                      ? tr.payment
                      : tr.orderSummary,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: _placing
          ? _buildPlacing(scheme, tr)
          : SafeArea(
              child: Column(
                children: [
                  _buildProgress(scheme),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppSpacing.screenPadding.copyWith(
                        top: AppSpacing.xl,
                        bottom: AppSpacing.xxl,
                      ),
                      child: switch (_step) {
                        0 => _buildDeliveryTypeStep(scheme),
                        1 => _buildLocationStep(scheme, tr),
                        2 => _buildPaymentStep(scheme),
                        3 => _buildConfirmStep(scheme, tr),
                        _ => const SizedBox.shrink(),
                      },
                    ),
                  ),
                  _buildBottomBar(scheme, tr),
                ],
              ),
            ),
    );
  }

  Widget _buildProgress(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        children: List.generate(_totalSteps, (i) {
          return Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(right: i < _totalSteps - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: i <= _step ? scheme.primary : scheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDeliveryTypeStep(ColorScheme scheme) {
    return CheckoutDeliveryTypeStep(
      selectedType: _deliveryType,
      onTypeSelected: (t) => setState(() => _deliveryType = t),
    );
  }

  Widget _buildLocationStep(ColorScheme scheme, AppLocalizations tr) {
    return CheckoutLocationStep(
      isDelivery: _deliveryType == DeliveryType.delivery,
      selectedDeliveryPoint: _selectedDeliveryPoint,
      selectedWarehouse: _selectedWarehouse,
      mapController: _mapController,
      cityController: _cityController,
      streetController: _streetController,
      apartmentController: _apartmentController,
      phoneController: _phoneController,
      onMapTap: (p) => setState(() => _selectedDeliveryPoint = p),
      onMapCreated: (c) => setState(() => _mapController = c),
      onWarehouseSelected: (w) => setState(() => _selectedWarehouse = w),
      onChanged: () => setState(() {}),
    );
  }

  Widget _buildPaymentStep(ColorScheme scheme) {
    return CheckoutPaymentStep(
      selectedMethod: _paymentMethod,
      onMethodSelected: (m) => setState(() => _paymentMethod = m),
    );
  }

  Widget _buildConfirmStep(ColorScheme scheme, AppLocalizations tr) {
    return CheckoutConfirmStep(
      items: _cart.items,
      deliveryType: _deliveryType,
      city: _cityController.text.trim(),
      street: _streetController.text.trim(),
      apartment: _apartmentController.text.trim(),
      phone: _phoneController.text,
      selectedWarehouse: _selectedWarehouse,
      paymentMethod: _paymentMethod,
      totalPrice: _cart.totalPrice,
    );
  }

  Widget _buildPlacing(ColorScheme scheme, AppLocalizations tr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            tr.placingOrder,
            style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme scheme, AppLocalizations tr) {
    final canProceed = _step == 0
        ? true
        : _step == 1
            ? (_deliveryType == DeliveryType.delivery
                ? _canProceedDelivery
                : _selectedWarehouse != null)
            : true;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.md,
        AppSpacing.base,
        MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: ElevatedButton(
          onPressed: canProceed ? _next : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            disabledBackgroundColor: scheme.outline,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: Text(
            _step < _totalSteps - 1 ? tr.continueBtn : tr.checkout,
            style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
          ),
        ),
      ),
    );
  }

}
