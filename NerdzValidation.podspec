

Pod::Spec.new do |s|
  s.name             = 'NerdzValidation'
  s.version          = '2.1.0'
  s.summary          = 'NERDZ LAB validation library'
  s.homepage         = 'https://github.com/nerdzlab/NerdzValidation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NerdzLab' => 'supernerd@nerdzlab.com' }
  s.source           = { :git => 'https://github.com/nerdzlab/NerdzValidation.git', :tag => s.version }
  s.social_media_url = 'https://nerdzlab.com'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '4.0'
  s.swift_versions = ['5.9']
  s.source_files = 'Sources/**/*'
end
