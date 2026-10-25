import 'package:blood_sugar_app_1/features/readings/domain/glucose_level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GlucoseLevel classify(int value) =>
      GlucoseLevel.classify(value, minTarget: 70, maxTarget: 140);

  test('classifies against the target range, bounds included', () {
    expect(classify(69), GlucoseLevel.low);
    expect(classify(70), GlucoseLevel.normal);
    expect(classify(140), GlucoseLevel.normal);
    expect(classify(141), GlucoseLevel.high);
  });
}
