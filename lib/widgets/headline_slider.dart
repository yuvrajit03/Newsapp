import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../bloc/get_top_headlines_bloc.dart';
import '../elements/error_element.dart';
import '../elements/loader_element.dart';
import '../models/articals.dart';
import '../models/articals_responce.dart';
import '../screen/news_details.dart';

class HeadlineSliderWidget extends StatefulWidget {
  @override
  _HeadlineSliderWidgetState createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc.getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }
          return _buildHeadlineSliderWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildErrorWidget("${snapshot.error}");
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSliderWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          enlargeCenterPage: false,
          height: 200.0,
          viewportFraction: 0.9,
        ),
        items: getSliderItems(articles),
      ),
    );
  }

  List<Widget> getSliderItems(List<ArticleModel> articles) {
    return articles.map((article) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailNews(
                        article: article,
                      )));
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 10.0,
            bottom: 10.0,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: article.img == null
                        ? const AssetImage("assets/img/placeholder.jpg")
                        : NetworkImage(article.img!) as ImageProvider<Object>,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.9],
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30.0,
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  width: 250.0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        article.title,
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 10.0,
                child: Text(
                  article.source.name,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9.0,
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: Text(
                  timeUntil(DateTime.parse(article.date)),
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
