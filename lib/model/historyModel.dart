class HistoryModel {
  int _id;
  String _time;
  String _src;
  String _coin;

  HistoryModel(this._time, this._src, this._coin);

   HistoryModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._time = map['time'];
    this._src = map['src'];
    this._coin= map['coin'];
  }

  int get id => _id;
  String get time => _time;
  String get src => _src;
  String get coin => _coin;



  // setter  
  set time(String value) {
    _time = value;
  }

  set src(String value) {
    _src = value;
  }
  set coin(String value) {
    _coin = value;
  }

  // konversi dari Contact ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['time'] = _time;
    map['src'] = _src;
    map['coin'] = _coin;
    return map;
  }  
}