class LoginData {
  String email;
  String password;

  LoginData({this.email, this.password,});

//  LoginData.fromSnapshot(DataSnapshot snapshot)
//      :
//        email = snapshot.key,
//        userId = snapshot.value["userId"],
//        subject = snapshot.value["subject"],
//        completed = snapshot.value["completed"];

  toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}