part of 'saved_qr_cubit.dart';

abstract class SavedQrState {}

class SavedQrInitial extends SavedQrState {}

class SavedQrLoading extends SavedQrState {}

class SavedQrSuccess extends SavedQrState {
  final String message;
  SavedQrSuccess(this.message);
}

class SavedQrFailure extends SavedQrState {
  final String message;
  SavedQrFailure(this.message);
}
