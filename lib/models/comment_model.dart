class CommentModel {
  final String userImage;
  final String userName;
  final String commentContent;

  CommentModel({
    required this.userImage,
    required this.userName,
    required this.commentContent,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userImage: json['userImage'] as String? ?? '',
      userName: json['userName'] as String,
      commentContent: json['commentContent'] as String,
    );
  }
}