alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias h='cd ~'
alias c='clear'

alias wip='git commit -am "WIP" && git pull origin HEAD --no-edit && git push -u origin HEAD'
alias pd='git pull --no-edit && git push -u origin HEAD && $(crane deploy > /dev/null 2>&1)'
alias fpd='git push -u origin HEAD && $(crane deploy --patch > /dev/null 2>&1)'

alias a='rlwrap php artisan'
alias tinker='rlwrap php artisan tinker'
alias migrate='rlwrap php artisan migrate'
alias db='mysql -h127.0.0.1 -uroot -psecret'

alias phpunit="vendor/bin/phpunit"
alias c="composer"
alias cu="composer update"
alias cr="composer require"
alias ci="composer install"
alias cda="composer dump-autoload"
alias gw="gulp watch"
alias update="git pull origin HEAD && composer update && yarn upgrade"

alias clearexif='for i in *; do echo "Processing $i"; exiftool -overwrite_original -all= "$i"; done'

export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

#  Commit everything
function commit() {
  commitMessage="$1"

  if [ "$commitMessage" = "" ]; then
     commitMessage="commit"
  fi

  git add .
  eval "git commit -a -m '${commitMessage}'"
}

# commit, push & deploy
function cpd() {
  if [ "$1" = "" ]; then
    echo "Commit message is required"
    return
  fi

  commit "$1"
  pd
}

function bg() {
	nohup "$@" &>/dev/null &
}

function open() {
	explorer.exe .
}

# Scrape a single webpage with all assets
function scrapePageWithAssets() {
    wget --adjust-extension --convert-links --page-requisites --span-hosts --no-host-directories "$1"
}

# Request using GET, POST, etc. method
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias week="date +%V"

export DISPLAY=:0

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    cat $tmpfile;
    rm -f $tmpfile;
}

resetdb() {
	if [ $# -eq 0 ]
	  then
		echo "No DB supplied"
		return
	fi
	mysql -h127.0.0.1 --user="root" --password="secret" --execute="DROP DATABASE $1; CREATE DATABASE $1;"
}

towerlink() {
	rm -rf vendor/enflow/tower vendor/enflow/tower-shop
	ln -s /home/michel/code/enflow/tower vendor/enflow/tower
	ln -s /home/michel/code/enflow/tower-shop vendor/enflow/tower-shop
}

link() {
    die () {
       echo >&2 "$@"
       exit 1
    }

    [ "$#" -eq 1 ] || die "1 argument required, $# provided"

    rm -rf "vendor/enflow/$1" "node_modules/$1"
    ln -s "/home/michel/code/enflow/$1" "vendor/enflow/$1"
    ln -s "/home/michel/code/vendor/$1" "node_modules/$1"
}

flavorlink() {
    die () {
       echo >&2 "$@"
       exit 1
    }

    [ "$#" -eq 1 ] || die "1 argument required, $# provided"

    rm -rf "vendor/enflow-flavors/$1"
    ln -s "/home/michel/code/enflow/flavors/$1" "vendor/enflow-flavors/$1"
}

restart() {
    sudo mkdir -p /var/run/php
    sudo service nginx restart
    sudo service php8.1-fpm restart
    sudo mkdir /var/run/mysqld && sudo chown mysql:mysql /var/run/mysqld
    sudo service mysql start
    sudo service redis-server start
    sudo service memcached start
}

function dusk() {
     pids=$(pidof /usr/bin/Xvfb)
 
     if [ ! -n "$pids" ]; then
         Xvfb :0 -screen 0 1280x960x24 &
     fi
 
     php artisan dusk "$@"
 }

gulp() {
    if [ -f "webpack.mix.js" ]; then
        command npm run watch
    else
        command gulp "$@"
    fi
}

# starting in the right directory
cd ~/code/enflow
