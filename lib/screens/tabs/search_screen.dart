import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news/elements/error_elements.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/article.dart';
import 'package:news/model/article_response.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news/bloc/search_bloc.dart';

import '../news_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBloc.search("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc.search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      icon: Icon(EvaIcons.backspaceOutline),
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc.search(_searchController.text);
                        });
                      })
                  : Icon(
                      EvaIcons.searchOutline,
                      color: Colors.grey,
                      size: 16.0,
                    ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
              labelText: "Search...",
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.grey),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.grey),
            ),
            autocorrect: false,
            autovalidate: true,
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleResponse>(
              stream: searchBloc.subject.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<ArticleResponse> snapshot) {
                if (snapshot.hasError) {
                  return buildErrorWidget(snapshot.error.toString());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return buildLoaderWidget();
                }

                return _buildSearchNews(snapshot.data);
              }),
        ),
      ],
    );
  }

  Widget _buildSearchNews(ArticleResponse? articleResponse) {
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

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
