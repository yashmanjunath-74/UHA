import 'package:fpdart/fpdart.dart';
import 'failure.dart';

/// A Future that resolves to Either a Failure or a value of type T.
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// A Future that resolves to Either a Failure or void (no return value).
typedef FutureEitherVoid = Future<Either<Failure, void>>;
