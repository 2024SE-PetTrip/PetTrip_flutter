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
    final addressParts = (json['groupAddress'] as String).split(' ');
    final province = addressParts.isNotEmpty ? addressParts[0] : '';
    final city = addressParts.length > 1 ? addressParts[1] : '';

    return WalkGroupModel(
      groupId: json['groupId'] as int,
      creatorId: json['creatorId'] as int,
      groupName: json['groupName'] as String,
      courseId: json['courseId'] as int,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      walkingDate: DateTime.parse(json['walkingDate']),
      maxParticipants: json['maxParticipants'] as int,
      maxPetsPerUser: json['maxPetsPerUser'] as int,
      groupDescription: json['groupDescription'] as String,
      province: province,
      city: city,
      tags: List<String>.from(json['tags']),
    );
  }
}
