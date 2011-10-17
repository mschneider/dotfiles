task :default => :install

desc "installs everything"
task :install => "install:all"

namespace :install do

  def install_task name, files
    desc "installs #{name.to_s} configuration"
    task name do
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

  install_task :git, "{.gitconfig,.global_gitignore}"
  install_task :rvm, ".rvmrc"
  install_task :ssh, ".ssh/*"
  install_task :zsh, ".zshrc"

end
