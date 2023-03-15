import 'dart:developer' as developer;

enum AppStatusCode {
  success,
  error,
  serverError,
  clientError,
  unauthorized,
  notFound,
  forbidden,
  badRequest,
  conflict,
  internalServerError,
  unknown,
}

class AppResponse {
  String id;
  AppStatusCode statusCode;
  String message;
  Map<String, dynamic> data;

  bool get isSuccess => statusCode == AppStatusCode.success;

  bool get isError => statusCode == AppStatusCode.error;

  bool get isNotFound => statusCode == AppStatusCode.notFound;

  AppResponse({
    required this.id,
    required this.statusCode,
    this.message = '',
    this.data = const {},
  });

  factory AppResponse.success({
    required String id,
    String message = '',
    Map<String, dynamic> data = const {},
  }) {
    return AppResponse(
      id: id,
      statusCode: AppStatusCode.success,
      message: message,
      data: data,
    );
  }

  factory AppResponse.notFound({
    required String id,
    String message = '',
    Map<String, dynamic> data = const {},
  }) {
    return AppResponse(
      id: id,
      statusCode: AppStatusCode.notFound,
      message: message,
      data: data,
    );
  }

  factory AppResponse.error({
    required String id,
    String? message,
    Map<String, dynamic> data = const {},
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return AppResponse(
      id: id,
      statusCode: AppStatusCode.error,
      data: data,
    );
  }

  log() {
    developer.log(
      'AppResponse.$id[$statusCode][$message][$data]',
    );
  }
}
