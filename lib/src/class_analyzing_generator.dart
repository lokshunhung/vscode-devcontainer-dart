import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:devcontainer_test/annotations.dart';
import 'package:source_gen/source_gen.dart';

class ClassAnalyzingGenerator extends GeneratorForAnnotation<ClassAnalyzable> {
  @override
  Iterable<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    if (element is ClassElement) {
      yield '// Library full name:  "${element.librarySource.fullName}"';
      yield '// Library short name: "${element.librarySource.shortName}"';
      yield '// Library uri:        "${element.librarySource?.uri.toString()}"';
      for (ConstructorElement constructorElement in element.constructors) {
        final constructorType = constructorElement.name == null
            ? 'null'
            : constructorElement.name == '' ? 'empty-string' : 'non-null';
        yield '// Constructor name is "${constructorElement.name}" ($constructorType)${constructorElement.isDefaultConstructor ? '@default' : ''}';

        final sb = StringBuffer('// Params:');
        for (ParameterElement paramElement in constructorElement.parameters) {
          final nam = paramElement.isNamed
              ? 'nam.'
              : paramElement.isPositional
                  ? 'pos.'
                  : 'non-named-and-positional.';
          final req = paramElement.isOptional ? 'opt' : 'req';
          final paramType =
              '$nam$req${paramElement.hasRequired ? '.reqAnnotated' : ''}';
          final nullability =
              paramElement.type.getDisplayString(withNullability: true);
          sb.write('\n// '
              'p:$paramType '
              'name:"${paramElement.name}" '
              'type:"${paramElement.type.element.librarySource?.uri.toString()}#${paramElement.type.element.name}"(${paramElement.type.nullabilitySuffix})[$nullability] '
              'id:"${paramElement.id}" ');
        }
        yield sb.toString();
      }
    }
  }
}
