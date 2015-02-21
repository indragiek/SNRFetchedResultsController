Pod::Spec.new do |spec|
  spec.name         = 'SNRFetchedResultsController'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/indragiek/SNRFetchedResultsController'
  spec.authors      = { 'Indragie Karunaratne' => 'i@indragie.com' }
  spec.summary      = 'Automatic Core Data change tracking for OS X (NSFetchedResultsController port).'
  spec.source       = { :git => 'https://github.com/indragiek/SNRFetchedResultsController.git', :tag => 'v0.0.1' }
  spec.source_files = 'SNRFetchedResultsController.{h,m}'
  spec.framework    = 'SystemConfiguration'
  spec.platform     = :osx
  spec.requires_arc = true
end
