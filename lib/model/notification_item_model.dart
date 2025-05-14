class NotificationItemModel {
  final String title;
  final String shortTitle;
  final String description;
  final DateTime createAt;

  NotificationItemModel({
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.createAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      title: json['title'],
      shortTitle: json['shortTitle'],
      description: json['description'],
      createAt: DateTime.parse(json['createAt']),
    );
  }
}
