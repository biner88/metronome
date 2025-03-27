#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint metronome.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'metronome'
  s.version          = '1.0.7'
  s.summary          = 'Metronome'
  s.description      = <<-DESC
Metronome
                        DESC
  s.homepage         = 'https://www.sumsg.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sumsg' => 'sumsg@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  # s.resources    = ['Assets/**.*']
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.resource_bundles = {'metronome_darwin_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
