class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.message, {this.statusCode = 0});

  @override
  String toString() => message;
}
