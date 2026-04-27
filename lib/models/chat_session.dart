import 'chat_message.dart';

class ChatSession {
  final String id;
  final String name;
  final List<ChatMessage> messages;
  final bool isStarred;
  final String? projectId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.name,
    required this.messages,
    this.isStarred = false,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'messages': messages.map((m) => m.toJson()).toList(),
      'isStarred': isStarred,
      'projectId': projectId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      name: json['name'],
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      isStarred: json['isStarred'] ?? false,
      projectId: json['projectId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  ChatSession copyWith({
    String? name,
    List<ChatMessage>? messages,
    bool? isStarred,
    String? projectId,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      id: id,
      name: name ?? this.name,
      messages: messages ?? this.messages,
      isStarred: isStarred ?? this.isStarred,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
