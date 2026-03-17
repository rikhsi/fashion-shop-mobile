import '../models/body_measurements_model.dart';
import '../models/custom_order_model.dart';

const _img = 'https://images.unsplash.com/';

abstract final class MockCustomOrders {
  static final BodyMeasurementsModel savedMeasurements = BodyMeasurementsModel(
    height: 175,
    weight: 70,
    chest: 96,
    waist: 82,
    hips: 98,
    shoulderWidth: 45,
    armLength: 62,
    legLength: 80,
    neckCirc: 39,
  );

  static final orders = <CustomOrderModel>[
    CustomOrderModel(
      id: 'co1',
      orderNumber: 'CS-2026001',
      type: CustomOrderType.fromProduct,
      status: CustomOrderStatus.inProduction,
      createdAt: DateTime(2026, 3, 5),
      measurements: savedMeasurements,
      productTitle: 'Silk Evening Blouse',
      productImageUrl: '${_img}photo-1564257631407-4deb1f99d992?w=400&h=500&fit=crop',
      productPrice: 189000,
      totalPrice: 289000,
      fabricChoice: 'Premium Silk',
      colorChoice: 'Ivory White',
      estimatedDelivery: DateTime(2026, 3, 25),
    ),
    CustomOrderModel(
      id: 'co2',
      orderNumber: 'CS-2026002',
      type: CustomOrderType.ownDesign,
      status: CustomOrderStatus.confirmed,
      createdAt: DateTime(2026, 3, 10),
      measurements: savedMeasurements,
      designImages: [
        '${_img}photo-1558618666-fcd25c85f82e?w=400&h=500&fit=crop',
        '${_img}photo-1562137369-1a1a0bc66744?w=400&h=500&fit=crop',
      ],
      designDescription:
          'I want a similar style evening dress in navy blue, with a slightly longer hem and no sleeves. '
          'Please use a breathable fabric suitable for summer.',
      totalPrice: 450000,
      fabricChoice: 'Cotton Blend',
      colorChoice: 'Navy Blue',
      estimatedDelivery: DateTime(2026, 4, 1),
    ),
    CustomOrderModel(
      id: 'co3',
      orderNumber: 'CS-2026003',
      type: CustomOrderType.fromProduct,
      status: CustomOrderStatus.delivered,
      createdAt: DateTime(2026, 2, 15),
      measurements: savedMeasurements,
      productTitle: 'Tailored Blazer',
      productImageUrl: '${_img}photo-1591047139829-d91aecb6caea?w=400&h=500&fit=crop',
      productPrice: 320000,
      totalPrice: 420000,
      fabricChoice: 'Wool Blend',
      colorChoice: 'Charcoal Gray',
      estimatedDelivery: DateTime(2026, 3, 2),
    ),
    CustomOrderModel(
      id: 'co4',
      orderNumber: 'CS-2026004',
      type: CustomOrderType.ownDesign,
      status: CustomOrderStatus.pending,
      createdAt: DateTime(2026, 3, 15),
      measurements: savedMeasurements,
      designImages: [
        '${_img}photo-1595777457583-95e059d581b8?w=400&h=500&fit=crop',
      ],
      designDescription: 'A casual linen shirt, relaxed fit, with wooden buttons.',
      totalPrice: 180000,
      fabricChoice: 'Linen',
      colorChoice: 'Sand Beige',
    ),
  ];
}
