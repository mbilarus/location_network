import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phone_auth_cubit_state.dart';
export 'phone_auth_cubit_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthCubitState> {
  PhoneAuthCubit() : super(PhoneAuthCubitInitial());

  Future<void> authWithPhone({required String smsCode}) async {
    if (state is PhoneAuthCubitVerificationIdReceived) {
      final verificationId = (state as PhoneAuthCubitVerificationIdReceived).verificationId;
        final user = (await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          ),
        ))
            .user;
        if (user != null) {
          emit(PhoneAuthCubitAuthSuccess(user: user));
        } else {
          emit(PhoneAuthCubitAuthFailed());
        }
      }
  }

  Future<void> verifyPhone({required String phoneWithoutCode}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+7$phoneWithoutCode',
      verificationCompleted: (PhoneAuthCredential credential) async {
        User? user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        emit(PhoneAuthCubitAuthSuccess(user: user));
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(PhoneAuthCubitVerifyFailed(error: e.toString()));
      },
      codeSent: (String verificationId, int? resendCode) {
        emit(PhoneAuthCubitVerificationIdReceived(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        emit(PhoneAuthCubitVerificationIdReceived(verificationId: verificationId));
      },
      timeout: const Duration(seconds: 120),
    );
  }
}