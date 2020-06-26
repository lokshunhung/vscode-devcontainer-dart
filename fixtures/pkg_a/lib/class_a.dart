import 'package:devcontainer_test/annotations.dart';
import 'package:meta/meta.dart';
import 'class_b.dart';

part 'class_a.g.dart';

@ClassAnalyzable()
class ClassA {
  ClassA(String p1, [int p2 = 1, int? p3]);

  ClassA.ctor(
    String cp,
    ClassB cncb, {
    @required String cn1,
    int? cn2,
    @required int cn3,
    @required ClassB cpcb,
  });
}
