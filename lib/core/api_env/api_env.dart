import 'package:flutter_dotenv/flutter_dotenv.dart';

final loginEndPoint = dotenv.get("LOGIN_END_POINT");
final registerEndPoint = dotenv.get("REGISTER_END_POINT");
final privacyPol = dotenv.get("PRIVACY_END_POINT");
final baseUrlApi = dotenv.get("BASE_URL");
final baseUrlApiMessage = dotenv.get("BASE_URL_MESSAGE");
final messageUrlApi = dotenv.get("MESSAGE_URL");