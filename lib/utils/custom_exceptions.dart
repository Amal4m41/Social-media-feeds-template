class Failure implements Exception {
  final String _msg;
  // final int msgCode; or we could just assign a message code which later would be mapped to a message while showing to the UI;

  const Failure(this._msg);

  @override
  String toString() => _msg;
}
