// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
//
// class VideoSelector extends StatefulWidget {
//   const VideoSelector({Key? key}) : super(key: key);
//
//   @override
//   State<VideoSelector> createState() => _VideoSelectorState();
// }
//
// class _VideoSelectorState extends State<VideoSelector> {
//   File? galleryFile;
//   VideoPlayerController? videoController;
//   final picker = ImagePicker();
//   bool isPlaying = true;
//   bool videoSelected = false;
//   bool isUploading = false;
//
//   @override
//   void dispose() {
//     videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(
//             child: Text(
//               'Video Editing App',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           backgroundColor: Colors.green,
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.edit),
//             )
//           ],
//         ),
//         body: Builder(
//           builder: (BuildContext context) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.green),
//                     ),
//                     child: Text(
//                       (videoSelected && videoController != null)
//                           ? 'Select Another Video'
//                           : 'Select Video',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     onPressed: () {
//                       _showPicker(context: context);
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   if (videoController != null)
//                     GestureDetector(
//                       onTap: () {
//                         _togglePlayPause();
//                       },
//                       child: Container(
//                         height: 300,
//                         width: 300,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.5),
//                               blurRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             VideoPlayer(videoController!),
//                             if (!isPlaying)
//                               const Icon(
//                                 Icons.play_arrow,
//                                 size: 50,
//                                 color: Colors.white,
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   if (videoSelected) // Display the buttons only if a video is selected
//                     Column(
//                       children: [
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(Colors.green),
//                           ),
//                           onPressed: () {
//                             // Upload video only if it is selected and not currently uploading
//                             if (galleryFile != null && !isUploading) {
//                               _uploadVideo();
//                             } else if (isUploading) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Video is currently being uploaded')),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('No video selected for upload')),
//                               );
//                             }
//                           },
//                           child: isUploading
//                               ? const CircularProgressIndicator() // Show loading indicator during upload
//                               : const Text(
//                             'Upload Video',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                         const SizedBox(height: 20,),
//                       ],
//                     ),
//                   if (!videoSelected) // Hide the button if no video is selected
//                     const SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.green),
//                     ),
//                     child: const Text(
//                       'Fetch Videos',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => VideoListFromFirestore(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Exit App'),
//         content: const Text('Do you really want to exit the app?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     )) ??
//         false;
//   }
//
//   void _togglePlayPause() {
//     if (videoController != null) {
//       if (isPlaying) {
//         videoController!.pause();
//       } else {
//         videoController!.play();
//       }
//       setState(() {
//         isPlaying = !isPlaying;
//       });
//     }
//   }
//
//   void _showPicker({
//     required BuildContext context,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () {
//                   getVideo(ImageSource.gallery);
//                   Navigator.of(context).pop();
//                   setState(() {
//                     videoSelected = true;
//                   });
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Camera'),
//                 onTap: () {
//                   getVideo(ImageSource.camera);
//                   Navigator.of(context).pop();
//                   setState(() {
//                     videoSelected = true;
//                   });
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> uploadVideoToFirebase(File videoFile) async {
//     setState(() {
//       isUploading = true;
//     });
//
//     try {
//       // Firebase Storage
//       String fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
//       Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
//       await storageReference.putFile(videoFile);
//
//       // Firestore
//       String downloadURL = await storageReference.getDownloadURL();
//       await saveVideoData(downloadURL);
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Video uploaded successfully')),
//       );
//
//       print('Video uploaded successfully. Download URL: $downloadURL');
//     } catch (e) {
//       print('Error uploading video to Firebase Storage: $e');
//     } finally {
//       setState(() {
//         isUploading = false;
//       });
//     }
//   }
//
//   Future<void> saveVideoData(String downloadURL) async {
//     try {
//       // Firestore
//       CollectionReference videos = FirebaseFirestore.instance.collection('videos');
//       await videos.add({
//         'downloadURL': downloadURL,
//       });
//     } catch (e) {
//       print('Error saving video metadata to Firestore: $e');
//     }
//   }
//
//   Future<void> getVideo(ImageSource img) async {
//     final pickedFile = await picker.pickVideo(
//       source: img,
//       maxDuration: const Duration(minutes: 10),
//     );
//
//     if (pickedFile != null) {
//       setState(() {
//         galleryFile = File(pickedFile.path);
//         videoController = VideoPlayerController.file(galleryFile!)
//           ..initialize().then((_) {
//             setState(() {
//               videoController!.setLooping(true);
//             });
//             videoController!.play();
//           });
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Nothing is selected')),
//       );
//     }
//   }
//
//   Future<void> _uploadVideo() async {
//     // Upload video to Firebase Storage
//     await uploadVideoToFirebase(galleryFile!);
//   }
// }
//
// class VideoListFromFirestore extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.green,
//         title: const Center(
//           child: Text(
//             'Firestore Video List',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('videos').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const CircularProgressIndicator();
//           }
//
//           List<DocumentSnapshot> documents = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               Map<String, dynamic> data = documents[index].data() as Map<
//                   String,
//                   dynamic>;
//               String videoURL = data['downloadURL'];
//
//               return ListTile(
//                 title: Text('Video $index'),
//                 onTap: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => VideoPlayerFromFirestore(videoURL: videoURL),
//                   //   ),
//                   // );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
