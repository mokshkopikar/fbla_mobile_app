import 'package:equatable/equatable.dart';

/// Base class for all business logic failures.
/// 
/// Instead of throwing raw exceptions which can crash the app,
/// the Domain and Data layers return Failures in a 'Result' or 'Either' type.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// A failure originating from a server connection or API response.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error occurred']);
}

/// A failure originating from local storage issues.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error occurred']);
}

/// A failure representing validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
