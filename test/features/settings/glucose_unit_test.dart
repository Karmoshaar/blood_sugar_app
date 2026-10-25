import 'package:blood_sugar_app_1/features/settings/domain/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mg/dL values are shown as whole numbers', () {
    expect(GlucoseUnit.mgDl.format(126.4), '126');
    expect(GlucoseUnit.mgDl.toMgDl(126.4), 126);
  });

  test('mmol/L converts both ways with one decimal', () {
    expect(GlucoseUnit.mmolL.format(126), '7.0');
    expect(GlucoseUnit.mmolL.toMgDl(5.5), 99);
    expect(GlucoseUnit.mmolL.fromMgDl(180), 10);
  });
}
