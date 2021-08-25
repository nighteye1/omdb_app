import 'package:flutter/material.dart';
import 'package:omdb_app/Model/moviesModel.dart';

class MovieDetail extends StatelessWidget {
  final MoviesModel movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        genre(context),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              runTime(context),
              imdbRating(context),
              metaScore(context),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          indent: MediaQuery.of(context).size.width * 0.2,
          endIndent: MediaQuery.of(context).size.width * 0.2,
          thickness: 1,
        ),
        plot(context),
        Divider(
          color: Colors.grey,
          indent: MediaQuery.of(context).size.width * 0.2,
          endIndent: MediaQuery.of(context).size.width * 0.2,
          thickness: 1,
        ),
        people(context),
        Divider(
          color: Colors.grey,
          indent: MediaQuery.of(context).size.width * 0.2,
          endIndent: MediaQuery.of(context).size.width * 0.2,
          thickness: 1,
        ),
        production(context),
        Divider(
          color: Colors.grey,
          indent: MediaQuery.of(context).size.width * 0.2,
          endIndent: MediaQuery.of(context).size.width * 0.2,
          thickness: 1,
        ),
      ],
    );
  }

  Widget runTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Runtime',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          movie.runtime!,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget imdbRating(BuildContext context) {
    return Column(
      children: [
        Text(
          'Imdb Rating',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              movie.imdbRating!,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            )
          ],
        ),
      ],
    );
  }

  Widget metaScore(BuildContext context) {
    return Column(
      children: [
        Text(
          'MetaScore',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.blue.shade900,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              movie.metaScore!,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            )
          ],
        ),
      ],
    );
  }

  Widget plot(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plot',
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            movie.plot!,
            maxLines: 10,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget people(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Director',
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              movie.director!,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Writer',
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              movie.writer!,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Actors',
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              movie.actors!,
              maxLines: 3,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget production(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          Text(
            'Production',
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            movie.production!,
            maxLines: 4,
            style: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget genre(BuildContext context) {
    List genres = movie.genre!.split(',');
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 10),
      height: 40,
      child: genres.isEmpty
          ? Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                movie.genre!,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            )
          : ListView.builder(
              itemCount: genres.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    genres[index],
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
    );
  }
}
