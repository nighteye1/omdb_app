import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:omdb_app/Bloc/omdb_bloc.dart';
import 'package:omdb_app/Bloc/omdb_event.dart';
import 'package:omdb_app/Bloc/omdb_state.dart';
import 'package:omdb_app/Model/moviesModel.dart';
import 'package:omdb_app/UI/Components/movie_detail.dart';

class MoviesPage extends StatefulWidget {
  final MoviesModel movie;
  final int index;
  const MoviesPage({Key? key, required this.movie, required this.index})
      : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  bool showSmallPoster = false;
  late OmdbBloc omdbBloc;
  OmdbState get initialState => InitialState();

  MoviesModel? fetchedMovie;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 400), () {
        setState(() {
          showSmallPoster = true;
        });
      });
    });
    omdbBloc = OmdbBloc(initialState);
    omdbBloc.add(FetchMovieEvent(
        title: widget.movie.title!, imdbId: widget.movie.imdbId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Hero(
                tag: widget.index,
                child: Image.network(
                  widget.movie.poster!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: MediaQuery.of(context).size.height * 0.35,
            left: showSmallPoster ? 20 : -70,
            child: Container(
              width: 70,
              height: 100,
              child: Image.network(
                widget.movie.poster!,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.41,
            left: 100,
            child: Container(
              width: MediaQuery.of(context).size.width - 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.movie.title!,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.movie.year!,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            child: BlocListener(
              bloc: omdbBloc,
              listener: (ctx, state) {
                if (state is FailureState) {
                  print('failure --- ${state.error}');
                }
                if (state is MovieFetchedState) {
                  fetchedMovie = state.movie;
                }
              },
              child: BlocBuilder(
                bloc: omdbBloc,
                builder: (ctx, state) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.49,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(right: 20),
                    child: state is LoadingState || state is InitialState
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : state is MovieFetchedState
                            ? MovieDetail(movie: fetchedMovie!)
                            : Container(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
