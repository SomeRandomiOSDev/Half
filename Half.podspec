Pod::Spec.new do |s|
  
  s.name         = "Half"
  s.version      = "1.1.0"
  s.summary      = "Swift Half-Precision Floating Point"
  s.description  = <<-DESC
                   A lightweight framework containing a Swift implementation for a half-precision floating point type for iOS, macOS, tvOS, and watchOS.
                   DESC
  
  s.homepage     = "https://github.com/SomeRandomiOSDev/Half"
  s.license      = "MIT"
  s.author       = { "Joseph Newton" => "somerandomiosdev@gmail.com" }

  s.ios.deployment_target     = '8.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source            = { :git => "https://github.com/SomeRandomiOSDev/Half.git", :tag => s.version.to_s }
  s.source_files      = 'Sources/**/*.{swift,h,c}'
  s.frameworks        = 'Foundation'
  s.swift_versions    = ['4.0', '4.2', '5.0']
  s.cocoapods_version = '>= 1.7.3'
  
end
