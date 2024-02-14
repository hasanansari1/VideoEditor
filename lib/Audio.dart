import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _pickVideo() async {
    final FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.video);
    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      File file = File(pickedFile.files.single.path!);
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file);
      _initializeVideoPlayerFuture = _videoController!.initialize();
      _videoController!.play();
      setState(() {});
    }
  }

  void _pickAudio() async {
    final FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.audio);
    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      File file = File(pickedFile.files.single.path!);
      _audioPlayer?.stop();
      await _audioPlayer?.setFilePath(file.path);
      _audioPlayer?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Picker Demo'),
      ),
      body: Center(
        child: _videoController == null
            ? Text('No media selected')
            : FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController!),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _pickVideo,
            tooltip: 'Pick Video',
            child: Icon(Icons.video_library),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _pickAudio,
            tooltip: 'Pick Audio',
            child: Icon(Icons.library_music),
          ),
        ],
      ),
    );
  }
}