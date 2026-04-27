import 'package:xml/xml.dart';

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory NewsArticle.fromXml(XmlElement element) {
    String getElementText(String name) {
      return element.findElements(name).isEmpty
          ? ''
          : element.findElements(name).first.innerText;
    }

    String img = '';
    final enclosure = element.findElements('enclosure');
    if (enclosure.isNotEmpty) {
      img = enclosure.first.getAttribute('url') ?? '';
    }
    if (img.isEmpty) {
      final media = element.findElements('media:content');
      if (media.isNotEmpty) {
        img = media.first.getAttribute('url') ?? '';
      }
    }

    return NewsArticle(
      title: getElementText('title'),
      description: getElementText('description'),
      url: getElementText('link'),
      imageUrl: img,
      publishedAt: getElementText('pubDate'),
    );
  }
}
