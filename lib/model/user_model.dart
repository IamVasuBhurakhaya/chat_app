class UserModal {
  String? uid, password, name, email, image, token;

  UserModal({
    required this.uid,
    required this.password,
    required this.name,
    required this.email,
    required this.image,
    required this.token,
  });

  factory UserModal.fromMap(Map m1) {
    return UserModal(
      uid: m1['uid'],
      password: m1['password'],
      name: m1['name'],
      email: m1['email'],
      image: m1['image'],
      token: m1['token'],
    );
  }

  Map<String, dynamic> get toMap => {
        'uid': uid,
        'password': password,
        'name': name,
        'email': email,
        'image': image,
        'token': token,
      };
}
