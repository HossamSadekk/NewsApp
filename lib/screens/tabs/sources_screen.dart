import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:news/bloc/sources_bloc.dart';
import 'package:news/elements/error_elements.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/source.dart';
import 'package:news/model/sources_response.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/source_details.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({Key? key}) : super(key: key);

  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
        stream: getSourcesBloc.subject.stream,
        builder:
            (BuildContext context, AsyncSnapshot<SourceResponse> snapshot) {
          if (snapshot.hasError) {
            return buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoaderWidget();
          }
          return _buildSources(snapshot?.data);
        });
  }

  Widget _buildSources(SourceResponse? data) {
    List<Source>? sources = data?.sources;
    return GridView.builder(
      itemCount: sources?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.86),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SourceDetails(sources?[index])));
            },
            child: Container(
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: sources?[index].id ?? "",
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/logos/${sources![index].id!}.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                    child: Text(
                      sources?[index].name ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
