import 'package:fpdart/fpdart.dart';
import 'package:boilerplate/core/errors/failures.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = Future<Either<Failure, void>>;
