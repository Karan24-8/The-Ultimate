class Event {
  final int date;
  final String name;
  final String time;
  final String location;
  final String categoryName;
  final String categoryImageUrl;

  Event({
    required this.date,
    required this.name,
    required this.time,
    required this.location,
    required this.categoryName,
    required this.categoryImageUrl,
  });

  factory Event.fromFirebase(Map<String, dynamic> data) {
    return Event(
      date: (data['date'] is int) ? data['date'] as int : int.tryParse(data['date']?.toString() ?? '0') ?? 0,
      name: data['name']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      categoryName: data['categoryName']?.toString() ?? '',
      categoryImageUrl: data['categoryImageUrl']?.toString() ?? '',
    );
  }
}
