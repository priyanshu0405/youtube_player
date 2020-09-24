import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:youtube_player/models/channel_model.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final Channel channel;

  VideoScreen({this.id, this.channel});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        disableDragSeek: false,
        autoPlay: true,
        hideControls: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: SwipeDetector(
        onSwipeLeft: () {
          _controller.load(widget
              .channel
              .videos[(widget.channel.videos.indexWhere(
                          (e) => e.id == _controller.metadata.videoId) +
                      1) %
                  widget.channel.videos.length]
              .id);
        },
        onSwipeRight: () {
          _controller.load(widget
              .channel
              .videos[(widget.channel.videos.indexWhere(
                          (e) => e.id == _controller.metadata.videoId) -
                      1) %
                  widget.channel.videos.length]
              .id);
        },
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  setState(() {
                    _isPlayerReady = true;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      iconSize: 30,
                      icon: Icon(
                        Icons.replay_10,
                      ),
                      onPressed: _isPlayerReady
                          ? () {
                              _controller.seekTo(Duration(
                                  seconds:
                                      _controller.value.position.inSeconds -
                                          10));
                            }
                          : null,
                    ),
                    IconButton(
                      color: Colors.white,
                      iconSize: 50,
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.play_arrow
                            : Icons.pause,
                      ),
                      onPressed: _isPlayerReady
                          ? () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                              setState(() {});
                            }
                          : null,
                    ),
                    IconButton(
                      iconSize: 30,
                      color: Colors.white,
                      icon: Icon(
                        Icons.forward_10,
                      ),
                      onPressed: _isPlayerReady
                          ? () {
                              _controller.seekTo(Duration(
                                  seconds:
                                      _controller.value.position.inSeconds +
                                          10));
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
