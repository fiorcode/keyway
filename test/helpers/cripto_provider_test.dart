import 'package:flutter_test/flutter_test.dart';

import 'package:keyway/providers/cripto_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Master Key creation', () async {
    bool result = await CriptoProvider.initialSetup('Qwe123!');
    expect(result, true);
  });
}
