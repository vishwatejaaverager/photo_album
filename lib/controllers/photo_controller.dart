import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/repositories/photo_repo.dart';
import '../models/photo.dart';

// State class
class PhotoState {
  final List<Photo> photos;
  final List<Photo> filteredPhotos;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String? errorMessage;

  PhotoState({
    required this.photos,
    required this.filteredPhotos,
    required this.isLoading,
    required this.hasMore,
    required this.page,
    this.errorMessage,
  });

  PhotoState copyWith({
    List<Photo>? photos,
    List<Photo>? filteredPhotos,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? errorMessage,
  }) {
    return PhotoState(
      photos: photos ?? this.photos,
      filteredPhotos: filteredPhotos ?? this.filteredPhotos,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ViewModel
class PhotoViewModel extends StateNotifier<PhotoState> {
  final PhotoRepository repository;

  PhotoViewModel(this.repository)
    : super(
        PhotoState(
          photos: [],
          filteredPhotos: [],
          isLoading: false,
          hasMore: true,
          page: 1,
        ),
      ) {
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final newPhotos = await repository.fetchPhotos(state.page);

      state = state.copyWith(
        photos: [...state.photos, ...newPhotos],
        filteredPhotos: [...state.photos, ...newPhotos],
        page: state.page + 1,
        hasMore: newPhotos.length == PhotoRepository.photosPerPage,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error: $e');
    }
  }

  void filterPhotos(String query) {
    final filtered =
        state.photos
            .where(
              (photo) =>
                  photo.title.toLowerCase().contains(query.toLowerCase()) ||
                  photo.id.toString().contains(query),
            )
            .toList();
    state = state.copyWith(filteredPhotos: filtered);
  }

  Map<int, List<Photo>> groupPhotosByAlbum() {
    final Map<int, List<Photo>> grouped = {};
    for (var photo in state.filteredPhotos) {
      grouped.putIfAbsent(photo.albumId, () => []).add(photo);
    }
    return grouped;
  }
}

// Provider with dependency injection
final photoViewModelProvider =
    StateNotifierProvider<PhotoViewModel, PhotoState>((ref) {
      final repository = ref.watch(photoRepositoryProvider);
      return PhotoViewModel(repository);
    });
