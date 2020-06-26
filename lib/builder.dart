import 'package:build/build.dart';
import 'package:devcontainer_test/src/class_analyzing_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder classAnalyzingBuilder(BuilderOptions options) =>
    SharedPartBuilder([ClassAnalyzingGenerator()], 'class_analyzing');
