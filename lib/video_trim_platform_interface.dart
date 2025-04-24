// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'video_trim_method_channel.dart';

abstract class VideoTrimPlatform extends PlatformInterface {
  /// Constructs a VideoTrimmer_2Platform.
  VideoTrimPlatform() : super(token: _token);

  static final Object _token = Object();

  static VideoTrimPlatform _instance = MethodChannelVideoTrim();

  /// The default instance of [VideoTrimPlatform] to use.
  ///
  /// Defaults to [MethodChannelVideoTrim].
  static VideoTrimPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VideoTrimPlatform] when
  /// they register themselves.
  static set instance(VideoTrimPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
