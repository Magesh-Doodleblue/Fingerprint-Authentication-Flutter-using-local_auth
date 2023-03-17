// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late int _currentVideoIndex = 0;

  List videoPaths = [
    "Cinematic_Cooking_promovideo.mp4",
    "Coffee.mp4",
    "deFood.mp4",
    "Dinning.mp4",
    "FoodReel.mp4",
    "Wildlife.mp4",
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset("assets/${videoPaths[_currentVideoIndex]}");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPreviousVideo() {
    setState(() {
      _currentVideoIndex = (_currentVideoIndex - 1) % videoPaths.length;
      _controller = VideoPlayerController.asset(
          "assets/${videoPaths[_currentVideoIndex]}");
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
    });
  }

  void _playNextVideo() {
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % videoPaths.length;
      _controller = VideoPlayerController.asset(
          "assets/${videoPaths[_currentVideoIndex]}");
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: const Color.fromARGB(255, 95, 13, 109),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black12,
                  ),
                  onPressed: () {
                    _playPreviousVideo();
                  },
                  child: const Icon(Icons.skip_previous),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[100],
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black12,
                  ),
                  onPressed: () {
                    _playNextVideo();
                  },
                  child: const Icon(Icons.skip_next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
