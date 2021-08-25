import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:omdb_app/Bloc/omdb_bloc.dart';
import 'package:omdb_app/Bloc/omdb_event.dart';
import 'package:omdb_app/Bloc/omdb_state.dart';
import 'package:async/async.dart';
import 'package:omdb_app/Model/moviesModel.dart';
import 'package:omdb_app/UI/Components/movie_item.dart';
import 'package:omdb_app/UI/Screens/movie_page.dart';
import 'package:omdb_app/Utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:rate_limiter/rate_limiter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late OmdbBloc omdbBloc;
  OmdbState get initialState => InitialState();

  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  String searchText = '';
  List<MoviesModel> movies = [];
  bool isLoading = false;
  int page = 1;
  ScrollController scrollController = ScrollController();
  double scrollPosition = 0.0;

  @override
  void initState() {
    omdbBloc = OmdbBloc(initialState);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('fetched more movies *****');
        getMoreMovies();
      }
    });
    super.initState();
  }

  getMoreMovies() {
    page += 1;
    omdbBloc.add(GetMoreMoviesEvent(title: searchController.text, page: page));
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          'OMDB Search App',
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          themeChange.darkTheme
              ? IconButton(
                  icon: Icon(
                    Icons.brightness_4,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    themeChange.darkTheme = false;
                  },
                )
              : IconButton(
                  icon: Icon(Icons.brightness_2,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    themeChange.darkTheme = true;
                  })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchField(),
          Expanded(
            child: Container(
              child: BlocListener(
                bloc: omdbBloc,
                listener: (ctx, state) {
                  if (state is FailureState) {
                    print(state.error);
                  }
                  if (state is MoviesListState) {
                    movies = state.movies;
                  }

                  if (state is MoreMoviesState) {
                    movies.addAll(state.movies);
                  }
                },
                child: BlocBuilder(
                  bloc: omdbBloc,
                  builder: (ctx, state) {
                    return ModalProgressHUD(
                      inAsyncCall: state is LoadingState,
                      child: movies.isEmpty
                          ? state is LoadingState || state is InitialState
                              ? Container()
                              : Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    'No movies found for your search :(',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: movies.length + 1,
                              itemBuilder: (ctx, index) {
                                if (index < movies.length &&
                                    movies[index].poster! == 'N/A') {
                                  movies[index].poster =
                                      "https://s.studiobinder.com/wp-content/uploads/2019/06/Movie-Poster-Template-Movie-Credits-StudioBinder.jpg.webp";
                                }
                                if (index == movies.length) {
                                  return Container(
                                      height: 50,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                }
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          pageBuilder: (_, __, ___) =>
                                              MoviesPage(
                                                  movie: movies[index],
                                                  index: index),
                                          transitionsBuilder:
                                              (BuildContext context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
                                                  Widget child) {
                                            return Align(
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: MovieItem(
                                      movie: movies[index],
                                      index: index,
                                    ));
                              },
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
              offset: const Offset(0.0, 1.0)),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: Color.fromRGBO(147, 148, 152, 1.0),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: 40,
            child: TextField(
              controller: searchController,
              style: TextStyle(
                color: Color.fromRGBO(147, 148, 152, 1.0),
              ),
              decoration: InputDecoration(
                hintText: "Search for movies...",
                hintStyle: TextStyle(
                  color: Color.fromRGBO(147, 148, 152, 1.0),
                ),
                border: InputBorder.none,
              ),
              onChanged: onTextChanged,
              onSubmitted: (value) {
                if (searchText == value) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                } else {
                  omdbBloc.add(SearchMovieEvent(title: value, page: page));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  onTextChanged(String text) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(seconds: 1), () {
      if (text.isEmpty) {
        setState(() {
          page = 1;
          movies = [];
        });
      } else {
        omdbBloc.add(SearchMovieEvent(title: text, page: page));
        setState(() {
          searchText = text;
        });
      }
    });
  }

  @override
  void dispose() {
    if (!mounted) {
      debounce?.cancel();
    }
    super.dispose();
  }
}
