class PetModel {
  final int userId; // 사용자 ID
  final String petName; // 반려동물 이름
  final int petAge; // 반려동물 나이
  final String breed; // 품종
  final String petImageUrl; // 이미지 URL
  final bool? validated; // 인증 여부 (Optional)

  // Constructor
  PetModel({
    required this.userId,
    required this.petName,
    required this.petAge,
    required this.breed,
    required this.petImageUrl,
    this.validated,
  });

  // fromJson: JSON 데이터를 객체로 변환
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      userId: json['userId'], // 사용자 ID
      petName: json['petName'], // 반려동물 이름
      petAge: json['petAge'], // 반려동물 나이
      breed: json['breed'], // 품종
      petImageUrl: json['petImageUrl'], // 이미지 URL
      validated: json['validated'], // 인증 여부 (Optional)
    );
  }

  // toJson: 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'petName': petName,
      'petAge': petAge,
      'breed': breed,
      'petImageUrl': petImageUrl,
      'validated': validated, // Optional field
    };
  }
}
