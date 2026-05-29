class Transaction {
  final String id;
  final String name;
  final String bitsId;
  final String vendor;
  final int amount;
  final String deviceId;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.name,
    required this.bitsId,
    required this.vendor,
    required this.amount,
    required this.deviceId,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      name: json['name'],
      bitsId: json['bitsId'],
      vendor: json['vendor'],
      amount: json['amount'],
      deviceId: json['deviceId'],
      timestamp: DateTime.parse(json['timestamp']).toLocal(),
    );
  }

  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return timestamp;
    }
  }
}