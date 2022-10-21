import 'package:flutter_login_vk/flutter_login_vk.dart';

abstract class VKAuthCubitState {}

class VKAuthCubitStateInitial extends VKAuthCubitState {}

class VKAuthCubitSuccess extends VKAuthCubitState {
  VKUserProfile? profile;
  String? email;
  VKAccessToken? accessToken;
  VKAuthCubitSuccess(
      {required this.profile, this.email, required this.accessToken});
}

class VKAuthCubitFailed extends VKAuthCubitState {
  String? error;
  VKAuthCubitFailed({required this.error});
}