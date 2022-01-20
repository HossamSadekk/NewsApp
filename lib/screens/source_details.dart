import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/source_news_bloc.dart';
import 'package:news/elements/error_elements.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/article.dart';
import 'package:news/model/article_response.dart';
import 'package:news/model/source.dart';
import 'package:news/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

import 'news_details.dart';

class SourceDetails extends StatefulWidget {
  Source? source;

  SourceDetails(this.source);

  @override
  _SourceDetailsState createState() => _SourceDetailsState(source);
}

class _SourceDetailsState extends State<SourceDetails> {
  Source? source;

  _SourceDetailsState(this.source);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          source?.name ?? "",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Style.ColorsApp.mainColor,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 15.0, top: 15.0),
            margin: EdgeInsets.only(bottom: 7.0),
            color: Style.ColorsApp.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source?.id ?? "",
                  child: Container(
                    height: 100.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/logos/${source?.id}.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  source?.name ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  source?.description ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<ArticleResponse>(
                  stream: getSourceNewsBloc.subject.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ArticleResponse> snapshot) {
                    if (snapshot.hasError) {
                      return buildErrorWidget(snapshot.error.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return buildLoaderWidget();
                    }

                    return _buildSourceNews(snapshot.data);
                  })),
        ],
      ),
    );
  }

  Widget _buildSourceNews(ArticleResponse? articleResponse) {
    List<Article>? articles = articleResponse?.articles;
    if (articles?.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("No Articles!"),
          ],
        ),
      );
    }

    return ListView.builder(
        itemCount: articles?.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsDetails(
                            article: articles![index],
                          )));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 3.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                ),
              ]),
              height: 150,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          articles?[index].title ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            timeAgo(
                                DateTime.parse(articles?[index].date ?? "")),
                            style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130.0,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/logos/axios.png',
                      image: articles?[index].img ?? "",
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/logos/axios.png',
                            fit: BoxFit.cover);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getSourceNewsBloc.getSourceNews(source?.id ?? "");
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
