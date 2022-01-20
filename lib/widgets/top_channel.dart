import 'package:flutter/material.dart';
import 'package:news/bloc/sources_bloc.dart';
import 'package:news/elements/error_elements.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/source.dart';
import 'package:news/model/sources_response.dart';
import 'package:news/screens/source_details.dart';

class TopChannels extends StatefulWidget {
  @override
  _TopChannelState createState() => _TopChannelState();
}

class _TopChannelState extends State<TopChannels> {
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

          return _buildTopChannels(snapshot.data);
        });
  }

  Widget _buildTopChannels(SourceResponse? sourceResponse) {
    List<Source>? source = sourceResponse?.sources;
    if (source?.length == 0) {
      return Container(
        child: Column(
          children: [
            Text("No Sources"),
          ],
        ),
      );
    }
    return Container(
      height: 115.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: source?.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              width: 80.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SourceDetails(source?[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: source?[index].id??"",
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/logos/${source![index].id!}.png")),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      source[index].name??"",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.4,
                          color: Colors.black,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      source[index].category??"",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.4,
                          color: Colors.black54,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    getSourcesBloc.getSources();
  }
}
