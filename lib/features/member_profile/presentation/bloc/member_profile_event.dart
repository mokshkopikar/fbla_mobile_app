part of 'member_profile_bloc.dart';

/// Base class for all events that can be triggered in the Member Profile feature.
abstract class MemberProfileEvent extends Equatable {
  const MemberProfileEvent();

  @override
  List<Object> get props => [];
}

/// Triggered when the profile needs to be loaded from the repository.
class GetProfileEvent extends MemberProfileEvent {}

/// Triggered when the user submits changes to their profile.
class UpdateProfileEvent extends MemberProfileEvent {
  final Member member;

  const UpdateProfileEvent(this.member);

  @override
  List<Object> get props => [member];
}
