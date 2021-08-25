import 'dart:convert';

import 'package:omdb_app/Model/moviesModel.dart';
import 'package:omdb_app/Utils/helper_functions.dart';

import 'omdb_event.dart';
import 'omdb_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class OmdbBloc extends Bloc<OmdbEvent, OmdbState> {
  OmdbBloc(OmdbState initialState) : super(initialState);
  String apiKey = 'cfcbe2fa';
  String url = 'http://www.omdbapi.com/?apikey=cfcbe2fa&s=';
  String singleMovieUrl = 'http://www.omdbapi.com/?apikey=cfcbe2fa&t=';
  String type = '&type=movie';
  static Map<String, MoviesModel> moviesData = Map();

  @override
  Stream<OmdbState> mapEventToState(OmdbEvent event) async* {
    if (event is SearchMovieEvent) {
      yield LoadingState();
      bool connection = await checkConnection();
      String modifiedTitle = event.title.replaceAll(' ', '+');
      String page = '&page=${event.page}';
      List<MoviesModel> movies = [];
      if (connection) {
        try {
          Uri uri = Uri.parse(url + modifiedTitle + type + page);
          print(uri);
          var response = await http.get(uri);

          if (response.statusCode == 200) {
            final parsed = jsonDecode(response.body);
            final result = parsed['Search'];

            movies = result
                .map<MoviesModel>((json) => MoviesModel.fromMap(json))
                .toList();

            print(movies.length);
          }

          yield MoviesListState(movies: movies);
        } catch (e) {
          yield FailureState(error: e.toString());
        }
      } else {
        yield FailureState(error: 'No Internet Connection');
      }
    }

    if (event is GetMoreMoviesEvent) {
      bool connection = await checkConnection();
      String modifiedTitle = event.title.replaceAll(' ', '+');
      String page = '&page=${event.page}';
      List<MoviesModel> movies = [];

      if (connection) {
        try {
          Uri uri = Uri.parse(url + modifiedTitle + type + page);
          print(uri);
          var response = await http.get(uri);

          if (response.statusCode == 200) {
            final parsed = jsonDecode(response.body);
            if (parsed['Response'] == 'False') {
              yield MoreMoviesState(movies: []);
            } else {
              final result = parsed['Search'];

              //print(parsed);

              movies = result
                  .map<MoviesModel>((json) => MoviesModel.fromMap(json))
                  .toList();

              print(movies.length);
            }
          }

          yield MoreMoviesState(movies: movies);
        } catch (e) {
          yield FailureState(error: e.toString());
        }
      } else {
        yield FailureState(error: 'No Internet Connection');
      }
    }

    if (event is FetchMovieEvent) {
      bool connection = await checkConnection();
      String modifiedTitle = event.title.replaceAll(' ', '+');
      MoviesModel movie = MoviesModel();

      if (connection) {
        try {
          if (moviesData.containsKey(event.imdbId)) {
            print('moviesData --- $moviesData');
            yield MovieFetchedState(movie: moviesData[event.imdbId]!);
          } else {
            yield LoadingState();
            Uri uri = Uri.parse(singleMovieUrl + modifiedTitle + type);
            var response = await http.get(uri);

            if (response.statusCode == 200) {
              Map<String, dynamic> parsed = jsonDecode(response.body);

              print('parsed -- $parsed');

              movie = MoviesModel.fromJson(parsed);
              moviesData[movie.imdbId!] = movie;
            }

            yield MovieFetchedState(movie: movie);
          }
        } catch (e) {
          yield FailureState(error: e.toString());
        }
      } else {
        yield FailureState(error: 'No Internet Connection');
      }
    }
  }
}
