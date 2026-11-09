import 'package:flutter_test/flutter_test.dart';
import 'package:boanh_catch_eat/main.dart';

void main() {
  testWidgets('BoAnh Catch and Eat app loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BoAnhApp());

    expect(find.text('BẮT ĐẦU CHƠI'), findsOneWidget);
    expect(find.text('CATCH & EAT'), findsOneWidget);
  });
}
