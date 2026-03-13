import 'package:fashion_shop/app.dart';
import 'package:fashion_shop/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await initDependencies();
  });

  tearDownAll(() async {
    await sl.reset();
  });

  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const FashionShopApp());
    await tester.pump();

    expect(find.byType(FashionShopApp), findsOneWidget);
  });
}
