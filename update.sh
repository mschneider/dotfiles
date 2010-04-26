export REPOSITORIES=$HOME/Repositories
export STABLE_RUBIES="1.8.6 1.8.7 1.9.1 1.9.2 ree rbx jruby maglev ironruby macruby"
export EDGE_RUBIES="rbx-head ruby-head ruby-1.8-head jruby-head"
export REDMINE=$HOME/redmine
export WORKSPACE=$HOME/Workspace

function announce() {
  echo -e "\033[0;32m$(date +%H:%m) \033[1;32m$@\033[m" >&2
}

function update_repository() {
  cd $REPOSITORIES
  if [ -d $1 ]; then
    announce "Updating $d"
    cd $1
    if [ -d .git ]; then git pull
    else if [ -d .svn ]; then svn up
    else if [ -d .hg ]; then hg pull
    else echo "no vcs" >&2; fi; fi
    fi
    cd -
  fi
  cd -
}

function cleanup_repositories() {
  for d in $REPOSITORIES/*/; do
    announce "Cleaning up $d"
    GIT_DIR="$d.git" git gc --aggressive
  done
}

function update_repositories() {
  cd $REPOSITORIES
  for d in *; do update_repository $d; done
  cd -
}

function update_homebrew() {
  announce "updating homebrew"
  brew update
}

function update_brew() {
  update_brew
  update_formulas
}

function update_formulas() {
  for p in $(brew outdated); do
    update_formula $p
  done
}

function update_formula() {
  announce "updating $1"
  brew install $1
  case $1 in
    mysql)      update_brew_launchd $1 com.mysql.mysqld.plist;;
    postgres)   update_brew_launchd $1 org.postgresql.postgres.plist;;
    memcached)  update_brew_launchd $1 com.danga.memcached.plist;;
    mongodb)    update_brew_launchd $1 org.mongodb.mongod.plist;;
  esac
}

function update_rvm() {
  announce "updating rvm"
  rvm update --head
  rvm reload
}

function update_stable_ruby() {
  rvm use $1 > /dev/null || update_edge_ruby $1
  rvm use default
}

function update_edge_ruby() {
  announce "updating $1"
  rvm install $1 -C --with-iconv-dir=$rvm_path/usr
}

function update_gems() {
  announce "updating rubygems"
  rvm gem update --system
  rvm gem update --no-verbose --development
  rvm gem update --prerelease --no-verbose --development
}

function update_rubies() {
  update_rvm
  for ruby in STABLE_RUBIES; do update_stable_ruby $ruby; done
  for ruby in EDGE_RUBIES;   do update_edge_ruby   $ruby; done
  update_gems
}

function update_brew_launchd() {
  launchctl unload -w ~/Library/LaunchAgents/$2
  for plist in /usr/local/Cellar/$1/*/$2; do
    cp $plist ~/Library/LaunchAgents/$2
  done
  launchctl load -w ~/Library/LaunchAgents/$2
}

function update_redmine() {
  announce "Merging redmine commits into finnlabs fork"
  cd $REDMINE
  git co master && git pull edavis10 master && git push origin master
  git co 0.9-stable && git pull edavis10 0.9-stable && git push origin 0.9-stable
  cd -
}

function update_redmine_dev_tools() {
  announce "Updateing redmine-dev-tools"
  cd $WORKSPACE/redmine-dev-tools
  git svn rebase
  git push
  cd -
}

function update_finnlabs() {
  update_redmine
  update_redmine_dev_tools
}

function update() {
  update_repositories
  update_brew
  update_rubies
  #cleanup_repositories
}
