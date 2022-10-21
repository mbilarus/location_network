import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';

import 'vk_auth_cubit_state.dart';
export 'vk_auth_cubit_state.dart';

class VKAuthCubit extends Cubit<VKAuthCubitState> {
  final vk = VKLogin();
  VKAuthCubit() : super(VKAuthCubitStateInitial());

  Future<void> _initSdk() async {
    await vk.initSdk();
  }

  Future<void> authFromVK() async {
    await _initSdk();
    var login = await vk.logIn(scope: [
      VKScope.email,
      VKScope.friends,
    ]);
    if(login.isValue) {
      VKLoginResult? loginResult = login.asValue!.value;
      _getUserData(loginResult);
    } else {
      emit(VKAuthCubitFailed(error: login.asError?.asValue?.value));
    }
  }

  Future<void> _getUserData(VKLoginResult loginResult) async {
      VKAccessToken? accessToken = loginResult.accessToken;
      VKUserProfile? profile = (await vk.getUserProfile()).asValue?.value;
      String? email = (await vk.getUserEmail());

      emit(
        VKAuthCubitSuccess(
          profile: profile,
          email: email,
          accessToken: accessToken,
        ),
      );
  }
}

