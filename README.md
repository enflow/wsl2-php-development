# WSL2 PHP Development

We use WSL2 (Bash on Windows) for local development on Windows.
You may install this on a Windows 10 machine with build 1904 or later (May 2020 release).

## Installing WSL2

- Open Powershell as administrator
- Run:
```
wsl --install
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
wsl --install -d Ubuntu
```
- Install Ubuntu from the Microsoft store and launch Ubunto from start
- WSL will install automatically. Please wait till the username prompt.
- Enter your username. We prefer to use our firstname in lowercase format: i.e. John Doe -> username 'john'
- Password should be 'secret'. We will remove the password later on.
- Run 'sudo apt update' & 'sudo apt upgrade -y' to update all dependencies
- WSL2 is installed! Now the dependencies.

# Installing dependencies

- `sudo su`
- `passwd --delete USERNAME`
- `touch ~/.hushlogin`
- `sudo add-apt-repository ppa:ondrej/php`
- `curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -`
- `curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -`
- `echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list`
- `apt update`
- `apt upgrade -y`
- Install PHP/webserver/database: `apt install -y php8.2-fpm php8.2-mbstring php8.2-curl php8.2-bz2 php8.2-zip php8.2-xml php8.2-gd php8.2-mysql php8.2-intl php8.2-sqlite3 php8.2-soap php8.2-bcmath php8.2-memcached php8.2-redis php8.2-xmlrpc php8.2-imagick apt-transport-https nginx mysql-client mysql-server`
- Optional dependencies: `apt install -y nodejs rlwrap git dos2unix memcached default-jre htop yarn unzip dh-autoreconf redis-server pv ack unoconv`
- `sudo npm install gulp-cli -g`
- `locale-gen nl_NL && locale-gen nl_NL.UTF-8 && locale-gen --purge`
- Copy your private key to the `~/.ssh/` directory

# nginx
Nginx needs to be configured. This depends on how you want to setup your vhosts. 
We've included our '/etc/nginx' folder (excluding the SSL certificates) in this repository as reference.
You can copy this directory to your /etc/nginx folder:
- Run `cd /etc/nginx && explorer.exe .` and copy the files from that folder over.
- You need to symlink the /etc/nginx/code folder to your code folder. We recommend this is under `~/code`

# php-fpm
We have some config items to change in the www PHP FPM pool:
`sudo nano /etc/php/8.2/fpm/pool.d/www.conf`
- `user` should be set to your username. Most likely your first name in lowercase.
- `group` should be set to your username. Most likely your first name in lowercase.
- `listen` should be set to `127.0.0.1:9250`
- You can save those changes.

# MySQL
We just need to set the root password to 'secret'. The other default configuration is fine for your usecase:
- `sudo usermod -d /var/lib/mysql/ mysql`
- `sudo service mysql start`
- `sudo mysql`
- Setting the root password to 'secret' for easy use:
- `use mysql;
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'secret';
    flush privileges;
    quit`
    
# Composer
Install Composer: https://getcomposer.org/download/

Move to global directory: `sudo mv composer.phar /usr/local/bin/composer`

Paste the following composer.json file to `~/.composer/composer.json`. You may change this to handle your usecases.
```
{
    "minimum-stability": "dev",
    "prefer-stable": true,
    "repositories": [
        {
            "type": "composer",
            "url": "https://satis.enflow.nl/"
        }
    ],
    "require": {
        "laravel/installer": "^4.2",
        "enflow/crane": "dev-master"
    }
}
```

Run `composer global update` to install those global dependencies.

# chromium (optional)
We use chromium with the puppeteer integration to create PDFs etc from webpages and running Laravel Dusk tests.

- `wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb`
- `sudo apt install -y ./google-chrome-stable_current_amd64.deb`
- verify using `google-chrome --version`

# SSL certificates
- Install https://brew.sh/ (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`)
- Install https://github.com/FiloSottile/mkcert (`/home/linuxbrew/.linuxbrew/bin/brew install mkcert`)
- Install mkcert `/home/linuxbrew/.linuxbrew/bin/mkcert -install`
- Create certificate. We ran the following, but depends on your subdomains/nginx configuration etc.
`/home/linuxbrew/.linuxbrew/bin/mkcert -ecdsa '*.enflow.test' '*.client.test' '*.crewplanner.client.test' '*.concept.test' '*.foundation.test' '*.private.test'`
- Move generated certificate and key to `/etc/dev-ssl/cert.pem` & `/etc/dev-ssl/key.pem`
- To install these for nginx, run `sudo ln -s /etc/dev-ssl /etc/nginx/ssl`
- Install the root certificates on your local machine. To find these, go to `cd /home/USERNAME/.local/share/mkcert`. Install the `rootCA.pem` via Chrome's certificate installer.

# Starting up
We've defined a `restart` function in our `~/.bash_aliases` file to help starting up. When your machine is started up, you need to run `restart` as the first commando to start all services up. This function should look something like:

```
sudo mkdir -p /var/run/php
sudo service nginx restart
sudo service php8.2-fpm restart
sudo mkdir /var/run/mysqld && sudo chown mysql:mysql /var/run/mysqld
sudo service mysql start
sudo service redis-server start
sudo service memcached start
```

For Enflow users: we've included our `~/.bash_aliases` file in this repository for copying.

# Terminal
We use Windows Terminal for a nice Terminal interface around WSL2. You can find that here:   
https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab

After launching, you need to configure WSL as a valid terminal. This is identified by the following guid: `{2c4de342-38b7-51cf-b940-2309a097f518}`

The easiest to do this is copy our Terminal file from this repository to the Terminal settings. You can find this under the "arrow down" icon in the top bar -> Settings.

# Wildcard DNS
We use Acrylic DNS on our Windows machine to automatically setup host files for our local development. For instance, 'app.enflow.test' would forward to '127.0.0.1'

Editing your host file for every foundation is pretty annoying. The recommended approach is to use a wildcard DNS server:

- Download & install [acrylic dns server](http://mayakron.altervista.org/wikibase/show.php?id=AcrylicHome).
- Run the 'Acrylic UI' program.
- Go to File -> Open Acrylic Configuration
  - Set the `AddressCacheDisabled` key to `Yes` to prevent DNS propagation cache issues.
  - Set `PrimaryServerAddress` to `1.1.1.1`
  - Set `LocalIPv4BindingAddress` to `127.0.0.1`
  - Save the changes (Ctrl+S)
- Go to File -> Open Acrylic Hosts
- Paste the following at the end of the file (these subdomains are specific to Enflow's use-case, modify where needed):
```
127.0.0.1 *.foundation.test
127.0.0.1 *.enflow.test
127.0.0.1 *.client.test
127.0.0.1 *.concept.test
127.0.0.1 *.private.test
```
- Edit your network device (LAN & WiFi if applicable) to use the `127.0.0.1` as primary DNS server and `1.1.1.1` as secondary DNS server as fallback for IPv4. For IPv6 use `::1` as primary and `2606:4700:4700::1111` as secondary.
More info about this can be found here: https://mayakron.altervista.org/support/acrylic/Windows10Configuration.htm

# Editing code
We recommend that the `~/code` folder is used on your WSL machine. Then you can access those files via `\\wsl$\Ubuntu\home\USERNAME\code`, where USERNAME would be your username configured (most likely your firstname in lowercase)

# Reference
- https://github.com/valeryan/valet-wsl/wiki/Installation-Guide
