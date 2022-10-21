import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required String username,
    required String phone,
    int? age,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json)
  => _$PersonFromJson(json);
}