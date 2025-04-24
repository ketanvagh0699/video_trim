#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'video_trim'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to trim videos on iOS and Android.'
  s.description      = <<-DESC
A Flutter plugin that uses AVFoundation on iOS and MediaExtractor+MediaMuxer on Android for video trimming.
                       DESC
  s.homepage         = 'https://github.com/ketanvagh0699/video_trim.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'vaghketan8387@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end