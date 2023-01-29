class Response<T> {
  bool error;
  String message;
  T? result;

  Response({
    required this.error, 
    required this.message, 
    this.result
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      error: json["error"],
      message: json["message"],
      result: json["result"],
    );
  }
}