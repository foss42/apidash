class Emoji {
  const Emoji({
    required this.char,
    required this.shortName,
    required this.unicode,
  });

  final String char;
  final String shortName;
  final String unicode;
}

class Hashtag {
  const Hashtag({
    required this.name,
    required this.weight,
    required this.description,
    required this.image,
  });

  final String name;
  final int weight;
  final String description;
  final String image;
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.createdAt,
    required this.sender,
  });

  final String text;
  final DateTime createdAt;
  final User sender;
}
