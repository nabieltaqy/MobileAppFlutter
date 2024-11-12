class User {
  final int id;
  final String nama;
  final String kota;
  final int usia;

  User({required this.id, required this.nama, required this.kota, required this.usia});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['Nama'], 
      kota: json['kota'], 
      usia: json['usia'],
    );
  }

  // Method untuk mengubah objek User menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Nama': nama,
      'kota': kota,
      'usia': usia,
    };
  }
}