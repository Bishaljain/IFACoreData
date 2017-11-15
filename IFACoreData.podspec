Pod::Spec.new do |s|
    s.name              = '     '
    s.version           = '1.0.0'
    s.summary           = 'Cocoa Touch framework containing enhancements on top of the CoreData framework for iOS apps and app extensions.'
    s.homepage          = 'https://github.com/marcelo-schroeder/IFACoreData'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '10.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/IFACoreData.git', :tag => 'v' +  s.version.to_s }
    s.source_files      = 'IFACoreData/IFACoreData/classes/**/*.{h,m,swift}'
    s.dependency 'IFAFoundation', '~> 2.0'
end
