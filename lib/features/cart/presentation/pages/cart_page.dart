import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../data/cart_service.dart';
import '../../data/models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cart = sl<CartService>();

  @override
  void initState() {
    super.initState();
    _cart.addListener(_refresh);
  }

  @override
  void dispose() {
    _cart.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _cart.isEmpty ? tr.cart : '${tr.cart} (${_cart.itemCount})',
            key: ValueKey(_cart.itemCount),
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          ),
        ),
        centerTitle: false,
        actions: [
          if (!_cart.isEmpty)
            TextButton(
              onPressed: () => _cart.clear(),
              child: Text(
                tr.clearCart,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _cart.isEmpty
            ? AppEmptyState(
                key: const ValueKey('empty'),
                icon: Icons.shopping_bag_outlined,
                title: tr.emptyCart,
                description: tr.emptyCartDescription,
              )
            : Column(
                key: const ValueKey('content'),
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: AppSpacing.screenPadding.copyWith(
                        top: AppSpacing.sm,
                        bottom: AppSpacing.base,
                      ),
                      itemCount: _cart.items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, i) {
                        final item = _cart.items[i];
                        return Dismissible(
                          key: ValueKey(item.product.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _cart.removeItem(item.product.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: AppSpacing.xl,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusLg,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              color: AppColors.error,
                            ),
                          ),
                          child: _CartItemTile(
                            item: item,
                            currency: tr.currency,
                            onIncrement: () => _cart.updateQuantity(
                              item.product.id,
                              item.quantity + 1,
                            ),
                            onDecrement: () => _cart.updateQuantity(
                              item.product.id,
                              item.quantity - 1,
                            ),
                            onRemove: () => _cart.removeItem(item.product.id),
                          ),
                        );
                      },
                    ),
                  ),
                  _CartSummary(
                    total: _cart.totalPrice,
                    currency: tr.currency,
                    deliveryLabel: tr.delivery,
                    freeLabel: tr.freeDelivery,
                    totalLabel: tr.orderTotal,
                    checkoutLabel: tr.checkout,
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Cart item tile ──

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final String currency;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.currency,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: SizedBox(width: 80, height: 100, child: _buildImage(scheme)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${item.product.formattedPrice} $currency',
                  style: AppTextStyles.price.copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _AnimatedQuantitySelector(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 22,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(ColorScheme scheme) {
    if (item.product.imageUrl != null && item.product.imageUrl!.isNotEmpty) {
      return Image.network(
        item.product.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: scheme.outlineVariant,
          child: Icon(Icons.image_outlined, color: scheme.onSurfaceVariant),
        ),
      );
    }
    return Container(
      color: scheme.outlineVariant,
      child: Icon(Icons.image_outlined, color: scheme.onSurfaceVariant),
    );
  }
}

// ── Animated quantity selector with sliding number ──

class _AnimatedQuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _AnimatedQuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyButton(Icons.remove_rounded, onDecrement, scheme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),
          _qtyButton(Icons.add_rounded, onIncrement, scheme),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, ColorScheme scheme) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Icon(icon, size: 18, color: scheme.onSurfaceVariant),
      ),
    );
  }
}

// ── Cart summary ──

class _CartSummary extends StatelessWidget {
  final double total;
  final String currency;
  final String deliveryLabel;
  final String freeLabel;
  final String totalLabel;
  final String checkoutLabel;

  const _CartSummary({
    required this.total,
    required this.currency,
    required this.deliveryLabel,
    required this.freeLabel,
    required this.totalLabel,
    required this.checkoutLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow(deliveryLabel, freeLabel, scheme, isBold: false),
            const SizedBox(height: AppSpacing.sm),
            Divider(color: scheme.outline),
            const SizedBox(height: AppSpacing.sm),
            _summaryRow(
              totalLabel,
              '${formatPrice(total)} $currency',
              scheme,
              isBold: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Text(
                  checkoutLabel,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value,
    ColorScheme scheme, {
    required bool isBold,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isBold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
              .copyWith(color: scheme.onSurface),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Text(
            value,
            key: ValueKey(value),
            style:
                (isBold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                    .copyWith(
                      color: isBold ? scheme.onSurface : AppColors.success,
                      fontWeight: isBold ? FontWeight.w700 : null,
                    ),
          ),
        ),
      ],
    );
  }
}
