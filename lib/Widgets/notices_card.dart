import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notices_app/Presentations/webViewScreen.dart';

class NoticeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String author;
  final String noticesUrl;
  final double elevation;

  const NoticeCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.author,
    required this.noticesUrl,
    this.elevation = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WebViewScreen(url: noticesUrl, title: title),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 140,
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 10),
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(author, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
