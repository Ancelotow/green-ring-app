
class User {
  String id;
  String login;
  int coins;
  String firstname;
  String lastname;
  bool admin;

  User({
    required this.id,
    required this.login,
    required this.coins,
    required this.firstname,
    required this.lastname,
    required this.admin,
});

  Map<String, dynamic> toJson() => {
    "_id": id,
    "login": login,
    "coins": coins,
    "firstname": firstname,
    "lastname": lastname,
    "admin": admin
  };

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        login = json['login'],
        coins = json['coins'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        admin = json['admin'];

}