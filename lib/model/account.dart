/// chat_box - account
/// Created by xhz on 28/05/2022
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:framework/list.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class PCLocalAccount extends BaseItemModel<String> {
  static final anonymous = PCLocalAccount(
    userinfo: UserInfo(userID: 'anonymous'),
    rememberPasswd: false,
    autologin: false,
  );

  @JsonKey(name: 'token')
  @HiveField(0)
  final String? token;

  @JsonKey(name: 'rem_passwd')
  @HiveField(1)
  final bool rememberPasswd;

  @JsonKey(name: 'autologin')
  @HiveField(2)
  final bool autologin;

  @JsonKey(name: 'userinfo')
  @HiveField(3)
  final UserInfo userinfo;

  const PCLocalAccount({
    required this.userinfo,
    required this.rememberPasswd,
    required this.autologin,
    this.token,
  });

  factory PCLocalAccount.fromJson(Map<String, dynamic> map) => _$PCLocalAccountFromJson(map);

  Map<String, dynamic> toJson() => _$PCLocalAccountToJson(this);

  PCLocalAccount copyWith({
    String? token,
    bool? rememberPasswd,
    bool? autologin,
    UserInfo? userinfo,
  }) =>
      PCLocalAccount(
        token: token ?? this.token,
        rememberPasswd: rememberPasswd ?? this.rememberPasswd,
        autologin: autologin ?? this.autologin,
        userinfo: userinfo ?? this.userinfo,
      );

  @override
  String get key => userinfo.userID ?? '';

  // TODO: 解析用户信息
  String get name {
    if (userinfo.nickname != null && userinfo.nickname!.isNotEmpty) {
      return userinfo.nickname!;
    }
    if (key.isNotEmpty) {
      return key;
    }
    return '未知';
  }
}

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final typeId = 2;

  @override
  UserInfo read(BinaryReader reader) {
    final micros = reader.readMap();
    return UserInfo.fromJson(micros as Map<String, dynamic>);
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer.writeMap(obj.toJson());
  }
}
