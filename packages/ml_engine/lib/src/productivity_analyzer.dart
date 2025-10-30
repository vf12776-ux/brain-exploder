class ProductivityAnalyzer {
  /// Анализирует паттерны продуктивности на основе данных GitHub
  Map<String, dynamic> analyzeProductivityPatterns(List<DateTime> commitTimes) {
    if (commitTimes.isEmpty) {
      return {'error': 'No data available'};
    }

    // Простой анализ - считаем коммиты по часам дня
    final hourCounts = List<int>.filled(24, 0);
    
    for (final time in commitTimes) {
      hourCounts[time.hour]++;
    }

    // Находим наиболее продуктивные часы
    final maxCount = hourCounts.reduce((a, b) => a > b ? a : b);
    final productiveHours = <int>[];
    
    for (int i = 0; i < hourCounts.length; i++) {
      if (hourCounts[i] == maxCount) {
        productiveHours.add(i);
      }
    }

    return {
      'total_commits': commitTimes.length,
      'most_productive_hours': productiveHours,
      'hourly_distribution': hourCounts,
      'recommendation': _generateRecommendation(productiveHours),
    };
  }

  String _generateRecommendation(List<int> productiveHours) {
    if (productiveHours.isEmpty) return 'Недостаточно данных для анализа';
    
    if (productiveHours.any((hour) => hour >= 22 || hour <= 6)) {
      return '🔥 Вы часто работаете ночью. Попробуйте перенести активность на дневное время для лучшего баланса.';
    } else if (productiveHours.any((hour) => hour >= 9 && hour <= 17)) {
      return '✅ Отличный баланс! Вы продуктивны в рабочие часы.';
    } else {
      return '💪 Вы находите время для кодирования в нестандартные часы. Продолжайте в том же духе!';
    }
  }
}