import 'package:butterfly/core/database/entity/user_entity.dart';
import 'package:butterfly/core/model/auth/user_response.dart';

class UserMapper {
  // Method to map UserResponse to UserEntity
  static Future<UserEntity> mapUserResponseToEntity(UserResponse userResponse) async {
    return UserEntity(
      id: userResponse.id,
      username: userResponse.username,
      email: userResponse.email,
      firstName: userResponse.firstName,
      lastName: userResponse.lastName,
      gender: userResponse.gender,
      image: userResponse.image,
      accessToken: userResponse.accessToken,
      refreshToken: userResponse.refreshToken,
    );
  }
}