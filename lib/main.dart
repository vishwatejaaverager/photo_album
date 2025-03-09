import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/views/home_screen.dart';

void main() {
  runApp(ProviderScope(child: PhotoAlbumApp()));
}

class PhotoAlbumApp extends StatelessWidget {
  const PhotoAlbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Album',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhotoGalleryScreen(),
    );
  }
}
