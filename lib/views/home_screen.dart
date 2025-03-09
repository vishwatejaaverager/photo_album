import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_album/controllers/photo_controller.dart';

class PhotoGalleryScreen extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();

  PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoViewModelProvider);
    final viewModel = ref.read(photoViewModelProvider.notifier);

    // Add scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !photoState.isLoading &&
          photoState.hasMore) {
        viewModel.fetchPhotos();
      }
    });

    final groupedPhotos = viewModel.groupPhotosByAlbum();

    return Scaffold(
      appBar: AppBar(title: Text('Photo Gallery')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by title or ID',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: viewModel.filterPhotos,
            ),
          ),
          if (photoState.errorMessage != null)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                photoState.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                ...groupedPhotos.entries.map((entry) {
                  return SliverStickyHeader(
                    header: Container(
                      height: 60.0,
                      color: Colors.lightBlue,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Album #${entry.key}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      delegate: SliverChildBuilderDelegate((context, i) {
                        final photo = entry.value[i];
                        return Card(
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: photo.thumbnailUrl,
                                placeholder:
                                    (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget:
                                    (context, url, error) => Icon(Icons.error),
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  photo.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: entry.value.length),
                    ),
                  );
                }),
                SliverToBoxAdapter(
                  child:
                      photoState.isLoading
                          ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
