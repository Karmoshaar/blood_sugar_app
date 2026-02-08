import 'package:flutter/cupertino.dart';
import '../account_setup/date_setup.dart';
import '../account_setup/gender_setup.dart';
import '../account_setup/height_setup.dart';
import '../account_setup/name_setup.dart';
import '../account_setup/remind_setup.dart';
import '../account_setup/weight_setup.dart';

class SetupFlowController extends StatefulWidget {
  final int step;

  const SetupFlowController({super.key, required this.step});

  @override
  State<SetupFlowController> createState() => _SetupFlowControllerState();
}

class _SetupFlowControllerState extends State<SetupFlowController> {
  @override
  void initState() {
    super.initState();
    _rebuildStack();
  }

  Future<void> _rebuildStack() async {
    await Future.delayed(Duration.zero);

    final routes = [
      const NameSetup(),
      const GenderSetup(),
      const DateSetup(),
      const WeightSetup(),
      const HeightSetup(),
      const RemindSetup(),
    ];

    for (int i = 1; i <= widget.step && i < routes.length; i++) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => routes[i],
          transitionDuration: Duration.zero, // بدون انيميشن 👻
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const NameSetup(); // أول شاشة بالستاك
  }
}
