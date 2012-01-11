task :default => :install

desc "installs everything"
task :install => "install:all"

def install! name, *files
  desc "installs #{name.to_s} configuration"
  task(name) do
    puts "\033[1;32minstalling #{name.to_s} configuration\033[0m"
    Dir.glob files do |file|
      source = File.expand_path file
      target = File.join ENV["HOME"], file
      FileUtils::Verbose.mkdir_p File.dirname(target)
      FileUtils::Verbose.rm_f target
      FileUtils::Verbose.ln_sf source, target
    end
  end
  task :all => name
end

namespace :install do
  install! :git, "{.gitconfig,.global_gitignore}"
  install! :rvm, ".rvmrc"
  install! :ssh, ".ssh/*"
  install! :zsh, ".zshrc"
end

