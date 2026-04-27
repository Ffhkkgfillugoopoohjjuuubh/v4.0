import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/news_article.dart';

class NewsService {
  final Map<String, _CachedNews> _cache = {};

  static const Map<String, String> _feeds = {
    'India': 'https://timesofindia.indiatimes.com/rssfeeds/296589292.cms',
    'Technology': 'https://feeds.feedburner.com/gadgets360-latest',
    'Education': 'https://www.thehindu.com/education/feeder/default.rss',
    'Science': 'https://www.thehindu.com/sci-tech/feeder/default.rss',
  };

  Future<List<NewsArticle>> fetchNews(String category) async {
    final now = DateTime.now();
    if (_cache.containsKey(category)) {
      final cached = _cache[category]!;
      if (now.difference(cached.timestamp).inMinutes < 15) {
        return cached.articles;
      }
    }

    try {
      final url = _feeds[category];
      if (url == null) return [];

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(utf8.decode(response.bodyBytes));
        final items = document.findAllElements('item');
        final articles = items.map((node) => NewsArticle.fromXml(node)).toList();
        
        _cache[category] = _CachedNews(articles: articles, timestamp: now);
        return articles;
      }
    } catch (e) {
      // Handle error
    }
    return _cache[category]?.articles ?? [];
  }
}

class _CachedNews {
  final List<NewsArticle> articles;
  final DateTime timestamp;

  _CachedNews({required this.articles, required this.timestamp});
}
