
Pod::Spec.new do |s|


s.name         = "TEST_SDK"
s.version      = "2.0.0"
s.summary      = "TEST_SDK 2.0.0"
s.description  = "Second of TEST_SDK 2.0.0"
s.homepage     = "https://github.com/leoxpx/TEST_SDK"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "许墨" => "zztixupx@gmail.com" }
s.platform     = :ios,'9.0'
s.source       = { :git => "https://github.com/leoxpx/TEST_SDK.git", :tag => "#{s.version}" }

#s.source_files  = "IGeShuiTax/**/*"
s.vendored_frameworks = 'IGeShuiTax/Frameworks/IGeShuiTaxSDK.framework'
s.frameworks = 'IGeShuiTaxSDK'
s.requires_arc = true



end

