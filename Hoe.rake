require 'hoe'

$LOAD_PATH.unshift('lib')
require 'automateit'
@interpreter = AutomateIt.new

HoeInclude = {
  :executables => Dir['bin/*'].reject{|t|t.match(/~/)}.map{|t|File.basename(t)},
  :files => (%w(env.sh gpl.txt CHANGES.txt Hoe.rake Manifest.txt Rakefile README.txt TESTING.txt TODO.txt TUTORIAL.txt) + FileList["{bin,examples,docs,lib,misc,spec}/**/*"]).to_a.reject{|t| File.directory?(t)},
  :test_files => FileList["{spec}/**/*"].to_a,
}

desc "Create manifest"
task :manifest do
  # Diff: rake -f Hoe.rake check_manifest
  items = Set.new(HoeInclude[:files])
  File.open("Manifest.txt", "w+"){|h| h.write(items.to_a.sort.join("\n")+"\n")}
end

Hoe.new("AutomateIt", AutomateIt::VERSION.to_s) do |s|
  s.author = "Igal Koshevoy"
  s.changes = s.paragraphs_of('CHANGES.txt', 0).join("\n")
  s.description = "AutomateIt is an open-source tool for automating the setup and maintenance of UNIX-like systems" 
  s.email = "igal@pragmaticraft.com"
  s.extra_deps = [["activesupport", ">= 1.4"], ["open4", ">= 0.9"]]
  s.name = "automateit"
  s.summary = "AutomateIt is an open-source tool for automating the setup and maintenance of UNIX-like systems" 
  s.url = "http://automateit.org/"
  s.spec_extras = {
    :platform => Gem::Platform::RUBY,
    :rdoc_options => %w(--main README.txt --promiscuous --accessor class_inheritable_accessor=R --title) << 'AutomateIt is an open-source tool for automating the setup and maintenance of UNIX-like systems.' << %w(lib docs),
    :extra_rdoc_files => FileList[%w(README.txt TUTORIAL.txt TESTING.txt), "docs/*.txt"],
  }
  s.spec_extras.merge!(HoeInclude)
end