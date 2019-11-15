import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:provider/provider.dart';

class AlbumsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final state = Provider.of<MusicProvider>(context);
    final settings = Provider.of<StartupProvider>(context);

    return Consumer<MusicProvider>(builder: (context, data, _) {
      return Container(
//        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        height: 160.0,
        child: data.albums.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.albums.length,
                itemBuilder: (BuildContext context, int index) {
                  Albums _album = data.albums[index];
                  if (index == 1) {
                    if (settings.userdata.paid == false)
                      return Consumer<AdsProvider>(
                        builder: (context, state, _) => state.sliderBanner,
                      );
                    else
                      return Container();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(
                        onTap: () {
                          data.getAlbumsTracks(id: _album.id);
                          Navigator.pushNamed(context, 'albumsongs',
                              arguments: _album);
                        },
                        child: Container(
                          width: 300.0,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: NetworkImage(_album.image),
                                fit: BoxFit.cover),
                            // color: Colors.blue
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 150,
                                child: Text(
                                  _album.title.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
            : Center(
                child: CupertinoActivityIndicator(),
              ),
      );
    });
  }
}
