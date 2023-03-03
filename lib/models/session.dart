import 'package:green_ring/models/user.dart';

class Session {

  static Session? _session;
  final User user;

  Session._({required this.user});

  static void open(User user) {
    _session ??= Session._(user: user);
  }

  static Session? instance() {
    return _session;
  }

  static void close() {
    _session = null;
  }

}