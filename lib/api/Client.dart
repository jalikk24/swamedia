import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Client {
  Future<Dio> initDio(GoogleSignInAccount user) async {

    return Dio(BaseOptions(
      baseUrl: "https://people.googleapis.com/v1/people/me/",
      headers: await user.authHeaders,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),));
  }
}