import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../../../core/usecases/usecase.dart';

part 'member_profile_event.dart';
part 'member_profile_state.dart';

/// Business Logic Component (BLoC) for Member Profile management.
/// 
/// [State Management]: BLoC separates the UI from the business logic.
/// It listens for [MemberProfileEvent]s and emits [MemberProfileState]s.
class MemberProfileBloc extends Bloc<MemberProfileEvent, MemberProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;

  MemberProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(MemberProfileInitial()) {
    
    // Mapping events to states
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  /// Handles fetching the profile data.
  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<MemberProfileState> emit,
  ) async {
    emit(MemberProfileLoading());
    try {
      final member = await getProfileUseCase(NoParams());
      emit(MemberProfileLoaded(member));
    } catch (e) {
      emit(const MemberProfileError('Failed to load profile data.'));
    }
  }

  /// Handles updating the profile data.
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<MemberProfileState> emit,
  ) async {
    emit(MemberProfileLoading());
    try {
      await updateProfileUseCase(event.member);
      // After a successful update, we reload the profile.
      add(GetProfileEvent());
    } catch (e) {
      emit(const MemberProfileError('Failed to update profile.'));
    }
  }
}
