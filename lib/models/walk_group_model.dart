class WalkGroupModel {
  final int creatorId;
  final String groupName;
  final int courseId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime walkingDate;
  final int maxParticipants;
  final int maxPetsPerUser;
  final String groupDescription;
  final String groupAddress;
  final List<String> tags;

  WalkGroupModel({
    required this.creatorId,
    required this.groupName,
    required this.courseId,
    required this.startDate,
    required this.endDate,
    required this.walkingDate,
    required this.maxParticipants,
    required this.maxPetsPerUser,
    required this.groupDescription,
    required this.groupAddress,
    required this.tags,
  });

  factory WalkGroupModel.fromJson(Map<String, dynamic> json) {
    return WalkGroupModel(
      creatorId: json['creatorId'] as int,
      groupName: json['groupName'] as String,
      courseId: json['courseId'] as int,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      walkingDate: DateTime.parse(json['walkingDate']),
      maxParticipants: json['maxParticipants'] as int,
      maxPetsPerUser: json['maxPetsPerUser'] as int,
      groupDescription: json['groupDescription'] as String,
      groupAddress: json['groupAddress'] as String,
      tags: List<String>.from(json['tags']),
    );
  }
}
