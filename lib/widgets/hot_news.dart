import 'package:flutter/material.dart';
import 'package:news/bloc/hotnews_bloc.dart';
import 'package:news/elements/error_elements.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/article_response.dart';
import 'package:news/model/article.dart';
import 'package:news/screens/news_details.dart';
import 'package:news/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

class HotNews extends StatefulWidget {
  @override
  _HotNewsState createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  late int a;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
        stream: getHotNews.subject.stream,
        builder:
            (BuildContext context, AsyncSnapshot<ArticleResponse> snapshot) {
          if (snapshot.hasError) {
            return buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoaderWidget();
          }
          a = snapshot.data?.articles?.length ?? 2000;
          return _buildHotNews(snapshot.data);
        });
  }

  Widget _buildHotNews(ArticleResponse? response) {
    List<Article>? articles = response?.articles;
    if (articles?.length == 0) {
      return Container(
        child: Column(
          children: [
            Text("No News"),
          ],
        ),
      );
    }

    return Container(
      height: a.toDouble() / 2 * 210.0,
      padding: EdgeInsets.all(5.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: articles?.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.85),
        // responsible for handling the grid layout, crossAxisCount is the number of items showing in cross-axis -- aspectRatio -> //adjust the height of the items
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsDetails(
                              article: articles![index],
                            )));
              },
              child: Container(
                width: 220.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(articles?[index].img??"https://image.tmdb.org/t/p/w92"),
                            )),




                        //NetworkImage(articles?[index].img??"")




                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                      child: Text(
                        articles?[index].title ?? "",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.3, fontSize: 15.0),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 180.0,
                          height: 1.0,
                          color: Colors.black12,
                        ),
                        Container(
                          width: 30.0,
                          height: 3.0,
                          color: style.ColorsApp.mainColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            articles?[index].source?.name ?? "",
                            style: TextStyle(
                                color: style.ColorsApp.mainColor,
                                fontSize: 9.0),
                          ), // SOURCE NAME
                          Text(
                            timeAgo(DateTime.parse(articles?[index].date??"2012-12-12")),
                            style: TextStyle(
                                color: style.ColorsApp.mainColor,
                                fontSize: 9.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getHotNews.getHotNews();
  }

  @override
  void dispose() {
    super.dispose();
    getHotNews.dispose();
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
