class CareModel {
  final String title;
  final String status;
  final String location;
  final String breed;

  CareModel({
    required this.title,
    required this.status,
    required this.location,
    required this.breed,
  });

  factory CareModel.fromJson(Map<String, dynamic> json) {
    return CareModel(
      title: json['title'],
      status: json['status'],
      location: json['location'],
      breed: json['breed'],
    );
  }
}
