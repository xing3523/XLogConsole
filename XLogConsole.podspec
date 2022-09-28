#
# Be sure to run `pod lib lint XLogConsole.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XLogConsole'
  s.version          = '1.0.2'
  s.summary          = 'Add a console print log to the app to facilitate troubleshooting'
  s.description      = <<-DESC
  The log can be displayed according to level, name, support keyword search, and export txt, etc.
                       DESC
  s.homepage         = 'https://github.com/xing3523/XLogConsole'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xing' => 'xinxof@foxmail.com' }
  s.source           = { :git => 'https://github.com/xing3523/XLogConsole.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.2', '5.0']
  s.default_subspec = 'Core'
  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Classes/*'
    ss.resource_bundles = {
       'XLogConsole' => ['Sources/Assets/*']
      }
  end
  s.subspec 'Helper' do |ss|
    ss.source_files = 'Sources/Helper/*'
    ss.dependency 'XLogConsole/Core'
  end
end
