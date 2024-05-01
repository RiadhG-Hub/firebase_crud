import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_example.freezed.dart';
part 'model_example.g.dart';

@freezed
class ModelExample with _$ModelExample {
  const factory ModelExample({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'fullName') String? fullName,
  }) = _ModelExample;

  factory ModelExample.fromJson(Map<String, Object?> json) => _$ModelExampleFromJson(json);
}
