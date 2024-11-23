class Item {
  final String title;
  final String status;
  final String location;
  final String breed;

  Item({
    required this.title,
    required this.status,
    required this.location,
    required this.breed,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      status: json['status'],
      location: json['location'],
      breed: json['breed'],
    );
  }
}
