import 'package:butterfly/data/remote/model/auth/login_request/login_request.dart';
import 'package:butterfly/data/remote/model/auth/user/user_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl,ParseErrorLogger? errorLogger,
}) = _AuthService;

  @POST('/auth/login')
  Future<UserResponse> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<UserResponse> register(@Body() Map<String, dynamic> body);

  @GET('/auth/me/{userId}')
  Future<UserResponse> getUserProfile(@Path('userId') String userId);
}