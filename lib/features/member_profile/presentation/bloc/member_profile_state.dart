part of 'member_profile_bloc.dart';

/// Base class for all states in the Member Profile feature.
abstract class MemberProfileState extends Equatable {
  const MemberProfileState();
  
  @override
  List<Object> get props => [];
}

/// The initial state when the page is first loaded.
class MemberProfileInitial extends MemberProfileState {}

/// State indicating that member data is being fetched or updated.
class MemberProfileLoading extends MemberProfileState {}

/// State containing the successfully loaded [Member] data.
class MemberProfileLoaded extends MemberProfileState {
  final Member member;

  const MemberProfileLoaded(this.member);

  @override
  List<Object> get props => [member];
}

/// State representing a failure in the member profile flow.
class MemberProfileError extends MemberProfileState {
  final String message;

  const MemberProfileError(this.message);

  @override
  List<Object> get props => [message];
}
