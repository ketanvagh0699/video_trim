import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import 'trimmer_platform_interface.dart';

/// Video trimmer class provides methods to trim video files
// class Trimmer {
//   final TrimmerPlatform _platform = TrimmerPlatform();

//   /// Trims a video file between the specified start and end times
//   ///
//   /// [file] - The input video file to trim
//   /// [startMs] - Start position in milliseconds
//   /// [endMs] - End position in milliseconds
//   ///
//   /// Returns a [Future] that completes with the trimmed video [File]
//   Future<File> trimVideo({
//     required File file,
//     required int startMs,
//     required int endMs,
//   }) async {
//     // Validate input parameters
//     if (!file.existsSync()) {
//       throw ArgumentError('Input video file does not exist: ${file.path}');
//     }

//     if (startMs < 0) {
//       throw ArgumentError('Start time cannot be negative: $startMs');
//     }

//     if (endMs <= startMs) {
//       throw ArgumentError(
//           'End time must be greater than start time: $endMs <= $startMs');
//     }

//     return _platform.trimVideo(file, startMs, endMs);
//   }

//   getPlatformVersion() {}
// }

enum TrimmerEvent { initialized }

class Trimmer {
  final TrimmerPlatform _platform = TrimmerPlatform();

  final StreamController<TrimmerEvent> _controller =
      StreamController<TrimmerEvent>.broadcast();

  VideoPlayerController? _videoPlayerController;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  File? currentVideoFile;

  /// Listen to this stream to catch the events
  Stream<TrimmerEvent> get eventStream => _controller.stream;

  /// Load a video file into the trimmer
  Future<void> loadVideo({required File videoFile}) async {
    currentVideoFile = videoFile;
    if (videoFile.existsSync()) {
      _videoPlayerController = VideoPlayerController.file(currentVideoFile!);
      await _videoPlayerController!.initialize().then((_) {
        _controller.add(TrimmerEvent.initialized);
      });
    }
  }

  /// Save a trimmed video from [startValue] to [endValue]
  Future<File> saveTrimmedVideo({
    required File file,
    required int startMs,
    required int endMs,
  }) async {
    final originalPath = _videoPlayerController!.dataSource;
    debugPrint('original path: $originalPath');
    // Validate input parameters
    if (!file.existsSync()) {
      throw ArgumentError('Input video file does not exist: ${file.path}');
    }

    if (startMs < 0) {
      throw ArgumentError('Start time cannot be negative: $startMs');
    }

    if (endMs <= startMs) {
      throw ArgumentError(
          'End time must be greater than start time: $endMs <= $startMs');
    }

    return _platform.trimVideo(file, startMs, endMs);
  }

  /// Generate a timestamp for unique file naming
  String _getTimestamp() {
    return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  }

  /// Dispose the video controller
  void dispose() {
    _controller.close();
    // _videoPlayerController?.pause();
    // _videoPlayerController?.dispose();
    // _videoPlayerController = null;
  }

  getPlatformVersion() {}

  // Future<bool> videoPlaybackControl({
  //   required double startValue,
  //   required double endValue,
  // }) async {
  //   if (videoPlayerController!.value.isPlaying) {
  //     await videoPlayerController!.pause();
  //     return false;
  //   } else {
  //     if (videoPlayerController!.value.position.inMilliseconds >=
  //         endValue.toInt()) {
  //       await videoPlayerController!
  //           .seekTo(Duration(milliseconds: startValue.toInt()));
  //       await videoPlayerController!.play();
  //       return true;
  //     } else {
  //       await videoPlayerController!.play();
  //       return true;
  //     }
  //   }
  // }

  Future<bool> videoPlaybackControl({
    required double startValue,
    required double endValue,
  }) async {
    final controller = _videoPlayerController;

    if (controller == null || !controller.value.isInitialized) {
      return false; // Controller is disposed or not ready
    }

    if (controller.value.isPlaying) {
      await controller.pause();
      return false;
    } else {
      if (controller.value.position.inMilliseconds >= endValue.toInt()) {
        await controller.seekTo(Duration(milliseconds: startValue.toInt()));
        await controller.play();
        return true;
      } else {
        await controller.play();
        return true;
      }
    }
  }
}
