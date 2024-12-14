class CareModel {
  final int requestId;
  final String title;
  final int petId;
  final String address;
  final String requestImageUrl;

  // Constructor
  CareModel({
    required this.requestId,
    required this.title,
    required this.petId,
    required this.address,
    required this.requestImageUrl,
  });

  // Factory constructor to create an instance from JSON
  factory CareModel.fromJson(Map<String, dynamic> json) {
    return CareModel(
      requestId: json['requestId'],
      title: json['title'],
      petId: json['petId'],
      address: json['address'],
      requestImageUrl: json['requestImageUrl'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'title': title,
      'petId': petId,
      'address': address,
      'requestImageUrl': requestImageUrl,
    };
  }
}

class CareRequestDTO {
  final int requesterId; // Long -> int
  final String title;
  final String address;
  final DateTime startDate; // LocalDateTime -> DateTime
  final DateTime endDate; // LocalDateTime -> DateTime
  final String requestDescription;
  final String requestImageUrl;
  final int petId; // Long -> int

  // Constructor
  CareRequestDTO({
    required this.requesterId,
    required this.title,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.requestDescription,
    required this.requestImageUrl,
    required this.petId,
  });

  // fromJson: JSON 데이터를 객체로 변환
  factory CareRequestDTO.fromJson(Map<String, dynamic> json) {
    return CareRequestDTO(
      requesterId: json['requesterId'] as int,
      title: json['title'] as String,
      address: json['address'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      requestDescription: json['requestDescription'] as String,
      requestImageUrl: json['requestImageUrl'] as String,
      petId: json['petId'] as int,
    );
  }

  // toJson: 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'requesterId': requesterId,
      'title': title,
      'address': address,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'requestDescription': requestDescription,
      'requestImageUrl': requestImageUrl,
      'petId': petId,
    };
  }
}

