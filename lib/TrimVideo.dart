// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_editor/video_editor.dart';
// import 'dart:io';
//
// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController? _controller;
//   File? _videoFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4')
//       ..initialize().then((_) {
//         setState(() {});
//         _controller!.play();
//       });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }
//
//   void _pickVideo() async {
//     final pickedFile =
//     await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _videoFile = File(pickedFile.path);
//         _controller = VideoPlayerController.file(_videoFile!)
//           ..initialize().then((_) {
//             setState(() {});
//             _controller!.play();
//           });
//       });
//     }
//   }
//
//   void _cropAndRotate() async {
//     if (_videoFile != null) {
//       final editedVideo = await VideoEditor.crop(
//         file: _videoFile!,
//         startTime: Duration.zero,
//         endTime: _controller!.value.duration,
//         preferredSize: Size(400, 400), // Set your preferred crop size
//         videoFormat: 'mp4', // Specify the video format as a string
//         quality: 100,
//       );
//
//       setState(() {
//         _videoFile = editedVideo;
//         _controller = VideoPlayerController.file(_videoFile!)
//           ..initialize().then((_) {
//             setState(() {});
//             _controller!.play();
//           });
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player Demo'),
//       ),
//       body: Center(
//         child: _videoFile == null
//             ? Text('No video selected.')
//             : _controller!.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller!.value.aspectRatio,
//           child: VideoPlayer(_controller!),
//         )
//             : CircularProgressIndicator(),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: _pickVideo,
//             tooltip: 'Pick Video',
//             child: Icon(Icons.video_library),
//           ),
//           SizedBox(height: 10),
//           FloatingActionButton(
//             onPressed: _cropAndRotate,
//             tooltip: 'Crop & Rotate Video',
//             child: Icon(Icons.crop_rotate),
//           ),
//         ],
//       ),
//     );
//   }
// }
