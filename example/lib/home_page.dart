import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:video_trim_example/trimmer_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Trimmer"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("LOAD VIDEO"),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.video,
              allowCompression: false,
            );
            // if (result != null) {
            //   File file = File(result.files.single.path!);
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => TrimmerView(file),
            //     ),
            //   );
            //   // Navigator.of(context).push(
            //   //   MaterialPageRoute(builder: (context) {
            //   //     return TrimmerView(file);
            //   //   }),
            //   // );
            // }
            if (result != null) {
              File file = File(result.files.single.path!);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );

              // Pre-initialize video if needed (optional optimization)
              // await somePreInitMethod(file);

              await Future.delayed(const Duration(milliseconds: 300));

              Navigator.of(context).pop();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TrimmerView(file),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
