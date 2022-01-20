import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/top_headlines_bloc.dart';
import 'package:news/model/article.dart';
import 'package:news/model/article_response.dart';
import 'package:news/elements/error_elements.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/screens/news_details.dart';
import 'package:timeago/timeago.dart' as time;

class HeadlineSliderWidget extends StatefulWidget{
  @override
  _HeadlineSliderWidgetState createState() => _HeadlineSliderWidgetState();
}
class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget>{
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream:getTopHeadlinesBloc.subject.stream,
        builder: (BuildContext context, AsyncSnapshot<ArticleResponse> snapshot) {
          if(snapshot.hasError){
            return buildErrorWidget(snapshot.error.toString());
          }
          else if(snapshot.connectionState == ConnectionState.waiting)
          {
            return buildLoaderWidget();
          }

          return _buildHeadlinesSlider(snapshot.data);
        }
    );
  }

  Widget _buildHeadlinesSlider(ArticleResponse? articleResponse){
    List<Article>? articles = articleResponse?.articles;
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: false,
          height: 200.0,
          viewportFraction: 0.9, // width of view
        ),
        items: getExpenseSliders(articles!),
      ),
    );
  }
  getExpenseSliders(List<Article> articles){
    return articles.map((article) =>
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetails(article: article,)));
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              top: 10.0,
              bottom: 10.0
            ),
            child: Stack(
              children: [
                Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(article?.img??"")
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.white.withOpacity(0.0)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                    width: 250.0,
                    child: Column(
                      children: [
                        Text(article.title??"",style: TextStyle(height:1.5,color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12.0),),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  child: Text(article.source?.name??"",style: TextStyle(color: Colors.white54,fontSize: 9.0),),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: Text(timeAgo(DateTime.parse(article.date!)),style: TextStyle(color: Colors.white54,fontSize: 9.0),),
                ),
              ],
            ),
          ),
        )
    ).toList();
  }
  @override
  void initState() {
   super.initState();
   getTopHeadlinesBloc.getHeadlines();
  }
  String timeAgo(DateTime date)
  {
    return time.format(date,allowFromNow: true,locale: 'en');
  }
}