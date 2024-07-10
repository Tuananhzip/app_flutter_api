class ApiResponse {
  bool success;
  String data;
  String error;

  ApiResponse({required this.success, required this.data, required this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
        success: json['success'], data: json['data'], error: json['error']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = data;
    data['error'] = error;
    return data;
  }

  @override
  String toString() {
    return 'ApiResponse{success: $success, data: $data, error: $error}';
  }
}
