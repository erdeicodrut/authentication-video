import 'dart:async';
import 'package:auth_app/features/names/service/name_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Names State
class NamesState {}

class NamesLoading extends NamesState {}

class NamesLoaded extends NamesState {
  final List<String> names;

  NamesLoaded(this.names);
}

class NamesError extends NamesState {
  final String error;

  NamesError(this.error);
}

// Names Events
abstract class NamesEvent {}

class FetchNamesEvent extends NamesEvent {}

class AddNameEvent extends NamesEvent {
  final String name;

  AddNameEvent(this.name);
}

// Names BLoC
class NamesBloc extends Bloc<NamesEvent, NamesState> {
  final NamesService namesService;

  NamesBloc(this.namesService) : super(NamesLoading()) {
    on<FetchNamesEvent>(
      (event, emit) async {
        try {
          final names = await namesService.getNames();
          emit(NamesLoaded(names));
        } catch (e) {
          emit(NamesError('Failed to retrieve names. Please try again later.'));
        }
      },
    );
    on<AddNameEvent>(
      (event, emit) async {
        try {
          await namesService.addName(event.name);
          emit(state); // Refresh the current state to trigger a rebuild
        } catch (e) {
          emit(NamesError('Failed to add name. Please try again later.'));
        }
      },
    );
  }
}
