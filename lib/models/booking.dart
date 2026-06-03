class BookingModel {
  const BookingModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.status,
    required this.price,
    this.notes,
  });

  final String id;
  final String userId;
  final String doctorId;
  final DateTime date;
  final String status;
  final int price;
  final String? notes;

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'doctorId': doctorId,
    'date': date.toIso8601String(),
    'status': status,
    'price': price,
    'notes': notes,
  };

  factory BookingModel.fromMap(Map<String, dynamic> json) => BookingModel(
    id: json['id'] ?? '',
    userId: json['userId'] ?? '',
    doctorId: json['doctorId'] ?? '',
    date: json['date'] != null ? DateTime.tryParse(json['date']) ?? DateTime.now() : DateTime.now(),
    status: json['status'] ?? 'قيد الأنتظار',
    price: int.tryParse(json['price'].toString()) ?? 0,
    notes: json['notes'],
  );

  BookingModel copyWith({
    String? id,
    String? userId,
    String? doctorId,
    DateTime? date,
    String? status,
    int? price,
    String? notes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      status: status ?? this.status,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }
}
