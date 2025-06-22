class User {
  final int? id;
  final String names;
  final String telephone;
  final String district;
  final String sector;
  final String cell;
  final String village;
  final String email;
  final String password;

  User({
    this.id,
    required this.names,
    required this.telephone,
    required this.district,
    required this.sector,
    required this.cell,
    required this.village,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'names': names,
      'telephone': telephone,
      'district': district,
      'sector': sector,
      'cell': cell,
      'village': village,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      names: map['names'],
      telephone: map['telephone'],
      district: map['district'],
      sector: map['sector'],
      cell: map['cell'],
      village: map['village'],
      email: map['email'],
      password: map['password'],
    );
  }
} 