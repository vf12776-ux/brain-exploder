import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/entities/github_activity.dart';

class GitHubApiClient {
  static const String _baseUrl = 'https://api.github.com';
  final String? _accessToken;

  GitHubApiClient([this._accessToken]);

  Future<List<GithubActivity>> getUserEvents(String username) async {
    final headers = {
      'Accept': 'application/vnd.github.v3+json',
      if (_accessToken != null) 'Authorization': 'token $_accessToken',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/users/$username/events'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> events = json.decode(response.body);
      return events.map((event) => _eventToActivity(event)).toList();
    } else {
      throw Exception('Failed to load GitHub events: ${response.statusCode}');
    }
  }

  GithubActivity _eventToActivity(Map<String, dynamic> event) {
    final commits = event['payload']?['commits']?.length ?? 0;
    
    return GithubActivity(
      timestamp: DateTime.parse(event['created_at']),
      eventType: event['type'],
      commits: commits,
      metadata: {
        'repo': event['repo']?['name'] ?? 'Unknown',
        'actor': event['actor']?['login'] ?? 'Unknown',
        'public': event['public'] ?? true,
      },
    );
  }
}
