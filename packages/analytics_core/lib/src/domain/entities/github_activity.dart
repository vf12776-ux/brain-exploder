import 'package:equatable/equatable.dart';

class GithubActivity extends Equatable {
  final DateTime timestamp;
  final String eventType;
  final int commits;
  final Map<String, dynamic> metadata;

  const GithubActivity({
    required this.timestamp,
    required this.eventType,
    required this.commits,
    required this.metadata,
  });

  @override
  List<Object?> get props => [timestamp, eventType, commits, metadata];
}