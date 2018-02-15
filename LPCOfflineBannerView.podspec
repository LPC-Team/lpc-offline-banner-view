Pod::Spec.new do |s|

  s.name         = "LPCOfflineBannerView"
  s.version      = "1.0.0"
  s.summary      = "LPCOfflineBannerView library"
  s.description  = "LPCOfflineBannerView is a library for displaying error message "
  s.homepage     = "https://github.com/LPC-Team/lpc-offline-banner-view-ios"
  s.license      = "MIT"
  s.author             = { "Alaeddine Ouertani" => "ouertani.alaeddine@gmail.com" }
  s.source       = { :git => "https://github.com/LPC-Team/lpc-offline-banner-view-ios.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "LPCOfflineBannerView/**/*.Swift"
  s.exclude_files = "Classes/Exclude"
  s.platform = :ios, '9.0'

end
