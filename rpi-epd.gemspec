Gem::Specification.new do |s|
  s.name        = 'rpi-epd'
  s.version     = '0.1'
  s.licenses    = ['MIT']
  s.summary     = "A library to display images on a EPD on a Rasberry Pi"
  s.description = "A library to display images on a EPD connected to a Raspberry Pi using the GPIO."
  s.authors     = ["Sindre Wetjen"]
  s.email       = ['sindre.w@gmail.com']
  s.homepage    = 'https://github.com/subfusc/rpi-epd'

  s.required_ruby_version = '~> 2.4'
  s.add_runtime_dependency 'spi'
  s.add_runtime_dependency 'rpi_gpio'

  s.files       = %x{git ls-files}.split("\n")
  s.executables   = %x{git ls-files -- bin/*}.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
