import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:eventsource/eventsource.dart' as en;
import 'package:example/trimmer_view.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
// import 'package:flutter_client_sse/flutter_client_sse.dart';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
// import 'package:http/http.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Trimmer"),
      ),
      body: Column(
        children: [
          TextButton(onPressed: () {}, child: Text("API check ")),
          Center(
            child: ElevatedButton(
              child: const Text("LOAD VIDEO"),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                  allowCompression: false,
                );
                if (result != null) {
                  File file = File(result.files.single.path!);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TrimmerView(file);
                    }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyPostRequestScreen extends StatefulWidget {
  @override
  _MyPostRequestScreenState createState() => _MyPostRequestScreenState();
}

class _MyPostRequestScreenState extends State<MyPostRequestScreen> {
  final StreamController<String> _streamController = StreamController<String>();
  dynamic percentage = 0;
  // en.EventSource? eventSource;
  Future<void> postData() async {
    var httpClient = HttpClient();
    try {
      try {
        SSEClient.subscribeToSSE(
            method: SSERequestType.GET,
            url:
                'https://api.propertise.com/upload/video/get_stream?videoPath=63ff37b0031cb72db844e843/feedback/1702873885959/Feedback.mp4',
            // 'https://api.propertise.com/upload/video/get_stream?videoPath=653752cad1ca7aa9b8672ed6/feedback/1703050355997/image_picker_0117A3C4-36E2-4EF5-9288-B45F4E54C0FB-3271-0000004B15A0AC60WhatsApp_Video_2023-12-05_at_2.32.09_PM-2727E78B-7BBD-491E-BCFB-C33BF0E952C0.mp4',
            header: {
              "Accept": "text/event-stream",
              "Cache-Control": "no-cache",
            }).listen(
          (event) {
            print('Id: ' + event.id!);
            print('Event: ' + event.event!);
            print('Data: ' + event.data!);
          },
        );

        // var request = await httpClient.getUrl(Uri.parse(
        //     'https://api.propertise.com/upload/video/get_stream?videoPath=63ff37b0031cb72db844e843/feedback/1702873885959/Feedback.mp4'));
        // var response = await request.close();

        // if (response.statusCode == HttpStatus.ok) {
        //   response
        //       .transform(utf8.decoder)
        //       .transform(const LineSplitter())
        //       .listen((String event) {
        //     print('Received event: $event');

        //     var sjson = jsonDecode('${event}');
        //     percentage = sjson['percentageOfCompleted'];
        //     setState(() {});
        //     print('Received event decode: ${sjson['percentageOfCompleted']}');

        //     // var encodedString = jsonEncode(event);

        //     // print('Received event encode: ${encodedString}');
        //     // dynamic valueMap = json.decode(encodedString);
        //     // print('Received event decode: ${valueMap['data']}');
        //     // print('Received event decode: ${json.encode(event)}');

        //     // Handle the received event data here
        //   }, onDone: () {
        //     print('Event stream closed.');
        //     httpClient.close();
        //   }, onError: (error) {
        //     print('Error in event stream: $error');
        //     httpClient.close();
        //   });
        // } else {
        //   print('Error connecting to EventSource: ${response.statusCode}');
        //   httpClient.close();
        // }
      } catch (e) {
        print('Error: $e');
      }
      ////======
      // ht.EventSource eventSource = ht.EventSource(
      //     'https://api.propertise.com/upload/video/get_stream?videoPath=63ff37b0031cb72db844e843/feedback/1702873885959/Feedback.mp4');

      // eventSource.onMessage.listen((ht.MessageEvent event) {
      //   var eventData = event.data;
      //   print('Received event: $eventData');
      //   // Handle the received event data here
      // });

      // eventSource.onError.listen((ht.Event error) {
      //   print('EventSource failed: $error');
      // });
      ////----
      // Replace the URL with your SSE endpoint
      // eventSource = await en.EventSource.connect(
      //   'https://api.propertise.com/upload/video/get_stream?videoPath=63ff37b0031cb72db844e843/feedback/1702873885959/Feedback.mp4',
      //   method: "GET",
      // );
      // log("message connect check -->${eventSource!.url}===> ${eventSource!.readyState} ");
      // eventSource!.onOpen.asyncMap((event) {
      //   log("message on open check --> ${event.data}");
      // });
      // eventSource!.onMessage.map((event) {
      //   log("message event check --> ${event.data}");
      // });

      // Listen to events
      // eventSource!.addEventListener('message', (Event event) {
      //   setState(() {
      //     eventData = event.data!;
      //   });
      // });

      // // Handle errors
      // eventSource.onError.listen((EventError error) {
      //   print('SSE Error: ${error.message}');
      // });

      ///POST REQUEST
      // SSEClient.subscribeToSSE(
      //     method: SSERequestType.GET,
      //     url: 'https://api.propertise.com/upload/video/get_stream',
      //     header: {
      //       "authorization":
      //           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2ZmMzdiMDAzMWNiNzJkYjg0NGU4NDMiLCJhdXRoVG9rZW4iOjU1MTI1OSwidXNlclR5cGUiOjAsInN0YXR1cyI6IkxvZ2luIiwiZ2VuZXJhdGVkT24iOjE2Nzc3NTA4NTIyNjQsImlhdCI6MTY3Nzc1MDg1Mn0.rPSq7y3mjezRyOclRHWVaSEXEDunGzlEdc-LYABx_to',
      //       "Accept": "text/event-stream",
      //       "Cache-Control": "no-cache",
      //       "Connection": "keep-alive",
      //     },
      //     body: {
      //       "location":
      //           "63ff37b0031cb72db844e843/feedback/1702873885959/Feedback.mp4"
      //     }).listen(
      //   (event) {
      //     log("message event data ---> ${event.data}");
      //     // print('Id: ' + event.id!);
      //     // print('Event: ' + event.event!);
      //     // print('Data: ' + event.data!);
      //     log('message event data --> ${json.decode(event.data!)["percentageOfCompleted"]}');
      //   },
      // );
    } catch (error) {
      _streamController.addError('Error: $error');
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POST Request with Stream Response'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                postData();
              },
              child: Text('Post Data'),
            ),
            SizedBox(height: 20),
            Text(
                "Completed -> ${percentage is int ? percentage : percentage.toStringAsFixed(2)}"),
            SizedBox(height: 20),
            StreamBuilder<String>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Stream Response: ${snapshot.data}');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Press the button to post data.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
