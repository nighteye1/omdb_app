import 'package:omdb_app/Model/moviesModel.dart';

abstract class OmdbState {}

class InitialState extends OmdbState {}

class LoadingState extends OmdbState {}

class MoviesListState extends OmdbState {
  final List<MoviesModel> movies;
  MoviesListState({required this.movies});
}

class MoreMoviesState extends OmdbState {
  final List<MoviesModel> movies;
  MoreMoviesState({required this.movies});
}

class MovieFetchedState extends OmdbState {
  final MoviesModel movie;
  MovieFetchedState({required this.movie});
}

class FailureState extends OmdbState {
  final String error;
  FailureState({required this.error});
}
