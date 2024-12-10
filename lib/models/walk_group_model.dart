class WalkGroupModel {
  final int groupId;
  final int creatorId;
  final String groupName;
  final int courseId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime walkingDate;
  final int maxParticipants;
  final int maxPetsPerUser;
  final String groupDescription;
  final String province;
  final String city;
  final List<String> tags;

  WalkGroupModel({
    required this.groupId,
    required this.creatorId,
    required this.groupName,
    required this.courseId,
    required this.startDate,
    required this.endDate,
    required this.walkingDate,
    required this.maxParticipants,
    required this.maxPetsPerUser,
    required this.groupDescription,
    required this.province,
    required this.city,
    required this.tags,
  });

  factory WalkGroupModel.fromJson(Map<String, dynamic> json) {
    final groupAddress = json['groupAddress'] as String? ?? '';
    final addressParts = groupAddress.split(' ');
    final province = addressParts.isNotEmpty ? addressParts[0] : '';
    final city = addressParts.length > 1 ? addressParts[1] : '';

    return WalkGroupModel(
      groupId: json['groupId'] != null ? json['groupId'] as int : 0,
      creatorId: json['creatorId'] != null ? json['creatorId'] as int : 0,
      groupName: json['groupName'] as String? ?? '',
      courseId: json['courseId'] != null ? json['courseId'] as int : 0,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
      walkingDate: json['walkingDate'] != null ? DateTime.parse(json['walkingDate']) : DateTime.now(),
      maxParticipants: json['maxParticipants'] != null ? json['maxParticipants'] as int : 0,
      maxPetsPerUser: json['maxPetsPerUser'] != null ? json['maxPetsPerUser'] as int : 0,
      groupDescription: json['groupDescription'] as String? ?? '',
      province: province ?? '',
      city: city ?? '',
      tags: json['tags'] != null
          ? (json['tags'] as List)
          .map((tag) => tag['tagName'] as String? ?? '')
          .toList()
          : [],
    );
  }
}
