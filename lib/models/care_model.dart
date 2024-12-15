class CareModel {
  final int requestId;
  final int? requesterId;
  final int? providerId;
  final String title;
  final String address;
  final DateTime startDate;
  final DateTime endDate;
  final String requestDescription;
  final String requestImageUrl;
  final int petId;
  final String status; // CareRequestStatus as String

  CareModel({
    required this.requestId,
    this.requesterId,
    this.providerId,
    required this.title,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.requestDescription,
    required this.requestImageUrl,
    required this.petId,
    required this.status,
  });

  factory CareModel.fromJson(Map<String, dynamic> json) {
    return CareModel(
      requestId: json['requestId'] as int,
      requesterId: json['requesterId'] as int?,
      providerId: json['providerId'] as int?,
      title: json['title'] as String,
      address: json['address'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      requestDescription: json['requestDescription'] as String,
      requestImageUrl: json['requestImageUrl'] as String? ?? '',
      petId: json['petId'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'requesterId': requesterId,
      'providerId': providerId,
      'title': title,
      'address': address,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'requestDescription': requestDescription,
      'requestImageUrl': requestImageUrl,
      'petId': petId,
      'status': status,
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

