
Pod::Spec.new do |s|


s.name         = "TEST_SDK"
s.version      = "1.1.1"
s.summary      = "TEST_SDK 1.1.1"
s.description  = "First of TEST_SDK 1.1.1"
s.homepage     = "https://github.com/leoxpx/TEST_SDK"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "许墨" => "zztixupx@gmail.com" }
s.platform     = :ios,'9.0'
s.source       = { :git => "https://github.com/leoxpx/TEST_SDK.git", :tag => "#{s.version}" }

#s.prefix_header_contents = "IGeShuiTaxSDK/IGeShuiTaxSDK/GSPrefixHeader.pch"
s.prefix_header_file = "TEST_SDK/TEST_SDK/GSPrefixHeader.pch"

s.source_files  = "TEST_SDK/**/*"
s.exclude_files = "Classes/Exclude"
s.requires_arc  = true
#s.requires_arc = "IGeShuiTaxSDK/IGeShuiTaxSDK/**/*"


end

