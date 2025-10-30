import 'package:flutter/material.dart';
import 'package:analytics_core/analytics_core.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  runApp(const BrainExploderApp());
}

class BrainExploderApp extends StatelessWidget {
  const BrainExploderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brain Exploder Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AdvancedDashboardScreen(),
    );
  }
}

class AdvancedDashboardScreen extends StatefulWidget {
  const AdvancedDashboardScreen({super.key});

  @override
  State<AdvancedDashboardScreen> createState() => _AdvancedDashboardScreenState();
}

class _AdvancedDashboardScreenState extends State<AdvancedDashboardScreen> {
  final GitHubApiClient _githubClient = GitHubApiClient();
  List<GithubActivity> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGitHubData();
  }

  Future<void> _loadGitHubData() async {
  try {
    print('🔄 Загружаем данные GitHub для: vf12776-ux');
    
    // Пытаемся получить реальные данные
    final activities = await _githubClient.getUserEvents('vf12776-ux');
    
    if (activities.isNotEmpty) {
      // Если есть реальные данные - используем их
      setState(() {
        _activities = activities;
        _isLoading = false;
      });
      print('✅ Найдено реальных активностей: ${activities.length}');
    } else {
      // Если реальных данных нет - используем реалистичные демо-данные
      setState(() {
        _activities = _getRealisticDemoData();
        _isLoading = false;
      });
      print('ℹ️ Реальных данных нет, используем демо-активности');
    }
  } catch (e) {
    // При ошибке тоже используем демо-данные
    setState(() {
      _activities = _getRealisticDemoData();
      _isLoading = false;
    });
    print('❌ Ошибка загрузки, используем демо-активности: $e');
  }
}

  List<GithubActivity> _getRealisticDemoData() {
  final now = DateTime.now();
  return [
    // Имитация работы над Brain Exploder проектом
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 7)),
      eventType: 'CreateEvent',
      commits: 1,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'action': 'created'},
    ),
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 6)),
      eventType: 'PushEvent',
      commits: 5,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'branch': 'main'},
    ),
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 5)),
      eventType: 'PushEvent', 
      commits: 3,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'branch': 'feature/ui'},
    ),
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 4)),
      eventType: 'PushEvent',
      commits: 8,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'branch': 'main'},
    ),
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 3)),
      eventType: 'IssuesEvent',
      commits: 0,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'action': 'opened'},
    ),
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 2)),
      eventType: 'PushEvent',
      commits: 12,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'branch': 'feature/ml'},
    ),
    GithubActivity(
      timestamp: now.subtract(const Duration(days: 1)),
      eventType: 'PushEvent',
      commits: 6,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'branch': 'main'},
    ),
    GithubActivity(
      timestamp: now,
      eventType: 'PushEvent',
      commits: 4,
      metadata: {'repo': 'vf12776-ux/brain_exploder', 'branch': 'hotfix'},
    ),
  ];
}
String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _translateEventType(String eventType) {
    switch (eventType) {
      case 'PushEvent': return 'Пуш в репозиторий';
      case 'CreateEvent': return 'Создание';
      case 'IssuesEvent': return 'Работа с Issues';
      case 'WatchEvent': return 'Звезда';
      case 'ForkEvent': return 'Форк';
      default: return eventType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Exploder 🚀'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadGitHubData,
          ),
        ],
      ),
      body: ParticleBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _buildDashboard(),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
  final commitData = _activities.map((a) => a.commits.toDouble()).toList();
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Brain Exploder 🚀',  // Изменил заголовок для единообразия
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      const SizedBox(height: 16),
      Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Commit Activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: commitData.isEmpty 
                    ? Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : AnimatedChart(
                        data: commitData,
                        color: Colors.blue,
                      ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Expanded(
        child: ListView.builder(
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            
            // Выбираем иконку по типу события
            IconData icon;
            Color iconColor;
            
            switch (activity.eventType) {
              case 'PushEvent':
                icon = Icons.code;
                iconColor = Colors.green;
                break;
              case 'CreateEvent':
                icon = Icons.create;
                iconColor = Colors.blue;
                break;
              case 'IssuesEvent':
                icon = Icons.bug_report;
                iconColor = Colors.orange;
                break;
              default:
                icon = Icons.event;
                iconColor = Colors.purple;
            }
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(icon, color: iconColor),
                title: Text('${activity.commits} коммитов в ${activity.metadata['repo']}'),
                subtitle: Text(
                  '${_formatDate(activity.timestamp)} - ${_translateEventType(activity.eventType)}',
                ),
                trailing: activity.commits > 0 
                    ? Chip(
                        label: Text('${activity.commits}'),
                        backgroundColor: Color.fromRGBO(0, 255, 0, 0.1), // Зеленый с прозрачностью 10%
                      )
                    : null,
              ),
            );
          },
        ),
      ), // Expanded
    ], // Column children
  ); // Column
} // _buildDashboard method

  // Вспомогательные методы
  
 
} // ← закрываем класс AdvancedDashboardScreen