part of derry;

/// find the source of the derry commands
Future<String> findSource() async {
  final pubspec = await readPubspec();
  final definitions = pubspec.contents.value['scripts'];

  if (definitions == null) {
    throw const Error(type: ErrorType.dnf);
  }

  if (definitions is YamlMap) {
    return 'pubspec.yaml';
  } else if (definitions is String) {
    final fileScripts = await readYamlFile(definitions.toString());

    if (fileScripts.contents.value is YamlMap) {
      return definitions;
    } else {
      throw const Error(type: ErrorType.cpd);
    }
  } else {
    throw const Error(type: ErrorType.cpd);
  }
}
