import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sentinelle/main.dart';
import 'package:sentinelle/providers/app_state.dart';

void main() {
  testWidgets('SentinelleApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const SentinelleApp(),
      ),
    );

    expect(find.text('Sentinelle Mali'), findsOneWidget);
  });
}
