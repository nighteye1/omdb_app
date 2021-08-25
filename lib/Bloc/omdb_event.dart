abstract class OmdbEvent {}

class SearchMovieEvent extends OmdbEvent {
  final String title;
  final int page;
  SearchMovieEvent({required this.title, required this.page});
}

class GetMoreMoviesEvent extends OmdbEvent {
  final String title;
  final int page;
  GetMoreMoviesEvent({required this.page, required this.title});
}

class FetchMovieEvent extends OmdbEvent {
  final String title;
  final String imdbId;
  FetchMovieEvent({required this.title, required this.imdbId});
}
