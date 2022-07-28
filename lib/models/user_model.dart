import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@unfreezed
class UserModel with _$UserModel {
  factory UserModel({
    required List<Map<String, dynamic>> habitDetails,
    required List<Map<String, dynamic>> habitRecords,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
}
