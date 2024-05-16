class SocketData {
  String? a;
  dynamic data;

  SocketData.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    data = (json['d']);
  }
}
