part of derry;

typedef executor_fn = Void Function(Pointer<Utf8>, Int32);
typedef Executor = void Function(Pointer<Utf8>, int);

// ignore: avoid_positional_boolean_parameters
void executor(String input, bool silent) {
  const rootLibrary = 'package:derry/derry.dart';
  final blobs = cli
      .waitFor(Isolate.resolvePackageUri(Uri.parse(rootLibrary)))
      .resolve('src/blobs/');
  final objectFile = blobs.resolve(getObject()).toFilePath();
  final dylib = DynamicLibrary.open(objectFile);

  final executorPointer = dylib.lookup<NativeFunction<executor_fn>>('executor');
  final executorFunction = executorPointer.asFunction<Executor>();

  final script = Utf8.toUtf8(input).cast<Utf8>();
  executorFunction(script, silent ? 1 : 0);
}
