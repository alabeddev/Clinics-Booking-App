class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.dname,
    required this.specialty,
    required this.available,
    required this.location,
    required this.price,
    required this.details,
    required this.evaluation,
  });
  final String id;
  final String dname;
  final String specialty;
  final List<String> available;
  final String location;
  final int price;
  final String details;
  final double evaluation;

  Map<String, dynamic> toMap() => {
    'id': id,
    'dname': dname,
    'specialty': specialty,
    'available': available,
    'location': location,
    'price': price,
    'details': details,
    'evaluation': evaluation,
  };

  factory DoctorModel.fromMap(Map<String, dynamic> json) => DoctorModel(
    id: json['id'] ?? '',
    dname: json['dname'] ?? '',
    specialty: json['specialty'] ?? '',
    available: List<String>.from(json['available'] ?? []),
    location: json['location'] ?? '',
    price: int.tryParse(json['price'].toString()) ?? 0,
    details: json['details'] ?? '',
    evaluation: double.tryParse(json['evaluation'].toString()) ?? 0,
  );
}
