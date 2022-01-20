import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news/model/article.dart';
import 'package:news/style/theme.dart' as Style;
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget {
  final Article article;

  const NewsDetails({Key? key,required this.article}) : super(key: key);

  @override
  _NewsDetailsState createState() => _NewsDetailsState(article);
}

class _NewsDetailsState extends State<NewsDetails> {
  final Article article;
  _NewsDetailsState(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: (){launch(article?.url);},
        child: Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          color: Style.ColorsApp.mainColor,
          child: Column(
            children: [
              Text("Read More",style: TextStyle(color: Colors.white,fontSize: 15.0),)
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Style.ColorsApp.mainColor,
        title: Text(article?.title??"",style: TextStyle(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: FadeInImage.assetNetwork(placeholder: 'assets/logos/axios.png', image: article?.img??"",fit: BoxFit.cover,),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0,),
                Text(article.date?.substring(0,10)??"",style: TextStyle(color: Style.ColorsApp.mainColor,fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                Text(article?.title??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.black),),
                SizedBox(height: 10.0,),
                Html(data: article?.content??"")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
