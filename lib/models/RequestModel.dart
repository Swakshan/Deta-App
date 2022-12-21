class RequestModel {
  String _method;
  String _uri;
  String _timeStamp;
  String _contentType;
  String? _body;

  RequestModel(
      this._method, this._uri, this._timeStamp, this._contentType, this._body);

  set body(String value) {
    _body = value;
  }

  set contentType(String value) {
    _contentType = value;
  }

  set timeStamp(String value) {
    _timeStamp = value;
  }

  set uri(String value) {
    _uri = value;
  }

  set method(String value) {
    _method = value.toUpperCase();
  }


  String get method => _method;

  @override
  String toString() {
    return 'RequestModel{_method: $_method, _uri: $_uri, _timeStamp: $_timeStamp, _contentType: $_contentType, _body: $_body}';
  }

  String str() {
    String rd;
    rd = "$_method\n$_uri\n$_timeStamp\n$_contentType\n$_body\n";
    if(_body==null) {
      rd = "$_method\n$_uri\n$_timeStamp\n$_contentType\n\n";
    }
    return rd;
  }

  String get uri => _uri;

  String get timeStamp => _timeStamp;

  String get contentType => _contentType;


}
