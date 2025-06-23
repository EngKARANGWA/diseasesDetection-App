class Agronomist {
  final int? id;
  final String names;
  final String telephone;
  final String district;
  final String sector;
  final String organizationEmail;
  final String licensePath;
  final String password;

  Agronomist({
    this.id,
    required this.names,
    required this.telephone,
    required this.district,
    required this.sector,
    required this.organizationEmail,
    required this.licensePath,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'names': names,
      'telephone': telephone,
      'district': district,
      'sector': sector,
      'organizationEmail': organizationEmail,
      'licensePath': licensePath,
      'password': password,
    };
  }

  factory Agronomist.fromMap(Map<String, dynamic> map) {
    return Agronomist(
      id: map['id'],
      names: map['names'],
      telephone: map['telephone'],
      district: map['district'],
      sector: map['sector'],
      organizationEmail: map['organizationEmail'],
      licensePath: map['licensePath'],
      password: map['password'],
    );
  }
} 