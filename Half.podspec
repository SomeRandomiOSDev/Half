Pod::Spec.new do |s|

  s.name         = "Half"
  s.version      = "1.3.2"
  s.summary      = "Swift Half-Precision Floating Point"
  s.description  = <<-DESC
                   A lightweight framework containing a Swift implementation for a half-precision floating point type for iOS, macOS, tvOS, and watchOS.
                   DESC

  s.homepage     = "https://github.com/SomeRandomiOSDev/Half"
  s.license      = "MIT"
  s.author       = { "Joe Newton" => "somerandomiosdev@gmail.com" }
  s.source       = { :git => "https://github.com/SomeRandomiOSDev/Half.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '11.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '11.0'
  s.watchos.deployment_target = '4.0'

  s.source_files      = 'Sources/**/*.{swift,h,c}'
  s.swift_versions    = ['4.0', '4.2', '5.0']
  s.cocoapods_version = '>= 1.7.3'

  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target     = '11.0'
    ts.macos.deployment_target   = '10.10'
    ts.tvos.deployment_target    = '11.0'
    ts.watchos.deployment_target = '4.0'

    ts.source_files              = 'Tests/CHalfTests/*Tests.swift',
                                   'Tests/HalfTests/*Tests.swift'
  end

end
