import 'dart:convert';

class MoviesModel {
  String? title;
  String? year;
  String? rated;
  String? released;
  String? runtime;
  String? genre;
  String? director;
  String? writer;
  String? actors;
  String? plot;
  String? language;
  String? country;
  String? awards;
  String? poster;
  String? metaScore;
  String? imdbRating;
  String? imdbVotes;
  String? imdbId;
  String? production;
  String? boxOffice;

  MoviesModel(
      {this.actors,
      this.awards,
      this.country,
      this.director,
      this.genre,
      this.imdbId,
      this.imdbRating,
      this.imdbVotes,
      this.language,
      this.metaScore,
      this.plot,
      this.poster,
      this.rated,
      this.released,
      this.runtime,
      this.title,
      this.writer,
      this.production,
      this.boxOffice,
      this.year});

  MoviesModel.fromJson(Map<String, dynamic> json)
      : title = json['Title'],
        year = json['Year'],
        rated = json['Rated'],
        released = json['Released'],
        runtime = json['Runtime'],
        genre = json['Genre'],
        director = json['Director'],
        writer = json['Writer'],
        actors = json['Actors'],
        plot = json['Plot'],
        language = json['Language'],
        country = json['Country'],
        awards = json['Awards'],
        poster = json['Poster'],
        metaScore = json['Metascore'],
        imdbRating = json['imdbRating'],
        imdbVotes = json['imdbVotes'],
        production = json['Production'],
        boxOffice = json['BoxOffice'],
        imdbId = json['imdbID'];

  factory MoviesModel.fromMap(Map<String, dynamic> json) => MoviesModel(
      title: json['Title'],
      year: json['Year'],
      rated: json['Rated'],
      released: json['Released'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      director: json['Director'],
      writer: json['Writer'],
      actors: json['Actors'],
      plot: json['Plot'],
      language: json['Language'],
      country: json['Country'],
      awards: json['Awards'],
      poster: json['Poster'],
      metaScore: json['Metascore'],
      imdbRating: json['imdbRating'],
      imdbVotes: json['imdbVotes'],
      production: json['Production'],
      boxOffice: json['BoxOffice'],
      imdbId: json['imdbID']);
}
