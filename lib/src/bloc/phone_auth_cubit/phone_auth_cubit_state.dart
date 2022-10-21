import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneAuthCubitState {}

class PhoneAuthCubitInitial extends PhoneAuthCubitState {}

class PhoneAuthCubitVerifyFailed extends PhoneAuthCubitState {
  final String error;
  PhoneAuthCubitVerifyFailed({required this.error});
}

class PhoneAuthCubitVerificationIdReceived extends PhoneAuthCubitState {
  final String verificationId;
  PhoneAuthCubitVerificationIdReceived({required this.verificationId});
}

class PhoneAuthCubitAuthSuccess extends PhoneAuthCubitState {
  final User? user;
  PhoneAuthCubitAuthSuccess({required this.user});
}

class PhoneAuthCubitAuthFailed extends PhoneAuthCubitState {}
