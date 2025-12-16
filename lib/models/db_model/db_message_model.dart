class Message {
  final int? id;
  final String sender;
  final String receiver;
  final String message;
  final int timestamp;

  Message({
    this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp,
    };
  }
}