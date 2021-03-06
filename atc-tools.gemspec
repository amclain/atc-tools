version = File.read(File.expand_path('../version', __FILE__)).strip

Gem::Specification.new do |s|
  s.name      = 'atc-tools'
  s.version   = version
  s.date      = Time.now.strftime '%Y-%m-%d'
  s.summary   = 'A VATSIM flight plan validator for the VRC radar client.'
  s.description = 
  "A VATSIM flight plan validator for the VRC radar client.
  NOTE: Only works with 32-bit Ruby installations due to the RAutomation gem."
  
  s.homepage  = 'https://bitbucket.org/amclain/atc-tools'
  s.authors   = ['Alex McLain']
  s.email     = 'alex@alexmclain.com'
  s.license   = 'MIT'
  
  s.files     =
    ['license.txt'] +
    Dir['bin/**/*'] +
    Dir['lib/**/*'] +
    Dir['doc/**/*']
  
  s.executables = [
    'fpv'
  ]
  
  s.add_dependency 'rautomation', '=0.12.0'
  s.add_dependency 'launchy',     '=2.3.0'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'pry'
end
