import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'video_trim_platform_interface.dart';

/// An implementation of [VideoTrimPlatform] that uses method channels.
class MethodChannelVideoTrim extends VideoTrimPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('video_trim');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
