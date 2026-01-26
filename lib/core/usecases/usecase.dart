import 'package:equatable/equatable.dart';

/// Abstract class for all UseCases.
/// 
/// [Single Responsibility Principle]: Each UseCase handles one specific 
/// business operation. 
/// 
/// [Type Parameters]:
/// [Type] - What the UseCase returns.
/// [Params] - What the UseCase needs to execute.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Helper class for UseCases that don't require parameters.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
