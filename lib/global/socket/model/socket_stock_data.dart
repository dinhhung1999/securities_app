class SocketStockData {
  late final String sym;
  late final String? mc;
  num? c;
  num? f;
  num? r;
  num? lastPrice;
  num? lastVolume;
  num? lot;
  num? ot;
  num? changePc;
  num? avePrice;
  num? highPrice;
  num? lowPrice;
  num? fBVol;
  num? fBValue;
  num? fSVolume;
  num? fSValue;
  num? fRoom;
  String? g1;
  String? g2;
  String? g3;
  String? g4;
  String? g5;
  String? g6;
  String? g7;
  String? mp;

  SocketStockData({
    required this.sym,
    this.mc,
    this.c,
    this.f,
    this.r,
    this.lastPrice,
    this.lastVolume,
    this.lot,
    this.ot,
    this.changePc,
    this.avePrice,
    this.highPrice,
    this.lowPrice,
    this.fBVol,
    this.fBValue,
    this.fSVolume,
    this.fSValue,
    this.fRoom,
    this.g1,
    this.g2,
    this.g3,
    this.g4,
    this.g5,
    this.g6,
    this.g7,
    this.mp,
  });

  SocketStockData.fromJson(Map<String, dynamic> json) {
    sym = json['sym'];
    mc = json['mc'];
    c = json['c'];
    f = json['f'];
    r = json['r'];
    lastPrice = json['lastPrice'];
    lastVolume = json['lastVolume'];
    lot = json['lot'];
    ot = num.parse(json['ot']);
    changePc = num.parse(json['changePc']);
    avePrice = num.tryParse(json['avePrice']) ?? 0;
    highPrice = num.tryParse(json['highPrice']) ?? 0;
    lowPrice = num.tryParse(json['lowPrice']) ?? 0;
    fBVol = num.tryParse(json['fBVol']) ?? 0;
    fBValue = num.tryParse(json['fBValue']) ?? 0;
    fSVolume = num.tryParse(json['fSVolume']) ?? 0;
    fSValue = num.tryParse(json['fSValue']) ?? 0;
    fRoom = num.tryParse(json['fRoom']) ?? 0;
    g1 = json['g1'];
    g2 = json['g2'];
    g3 = json['g3'];
    g4 = json['g4'];
    g5 = json['g5'];
    g6 = json['g6'];
    g7 = json['g7'];
    mp = json['mp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sym'] = sym;
    data['mc'] = mc;
    data['c'] = c;
    data['f'] = f;
    data['r'] = r;
    data['lastPrice'] = lastPrice;
    data['lastVolume'] = lastVolume;
    data['lot'] = lot;
    data['ot'] = ot;
    data['changePc'] = changePc;
    data['avePrice'] = avePrice;
    data['highPrice'] = highPrice;
    data['lowPrice'] = lowPrice;
    data['fBVol'] = fBVol;
    data['fBValue'] = fBValue;
    data['fSVolume'] = fSVolume;
    data['fSValue'] = fSValue;
    data['fRoom'] = fRoom;
    data['g1'] = g1;
    data['g2'] = g2;
    data['g3'] = g3;
    data['g4'] = g4;
    data['g5'] = g5;
    data['g6'] = g6;
    data['g7'] = g7;
    data['mp'] = mp;
    return data;
  }

  num? parseNumData(dynamic data) {
    if (data is String) {
      num.tryParse(data);
    }
    if (data is num) {
      return data;
    }
    return null;
  }

  int? parseIntData(dynamic data) {
    if (data is String) {
      int.tryParse(data);
    }
    if (data is int) {
      return data;
    }
    return null;
  }

  double? parseDoubleData(dynamic data) {
    if (data is double) {
      return data;
    }
    if (data is String) {
      return double.tryParse(data);
    }
    return null;
  }
}
