# WSL2 PHP Development

We use WSL2 (Bash on Windows) for local development on Windows.
You may install this on a Windows 10 machine with build 1904 or later (May 2020 release).

## Installing WSL2

- Open Powershell as administrator
- `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
- `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
- You need to restart your Windows machine (required).
- Open Powershell as administrator once again
- `wsl --set-default-version 2`
- Install Ubuntu from the Microsoft store and launch Ubunto from start
- WSL will install automatically. Please wait till the username prompt.
- Enter your username. We prefer to use our firstname in lowercase format: i.e. John Doe -> username 'john'
- Password should be 'secret'. We will remove the password later on.
- Run 'sudo apt update' & 'sudo apt upgrade -y' to update all dependencies
- WSL2 is installed! Now the dependencies.

# Installing dependencies

- `sudo su`
- `passwd --delete USERNAME`
- `add-apt-repository ppa:ondrej/php`
- `curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -`
- `curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -`
- `echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list`
- `apt update`
- `apt upgrade -y`
- `apt install -y apt-transport-https php7.4-fpm php7.4-mbstring php7.4-curl php7.4-json php7.4-bz2 php7.4-zip php7.4-xml php7.4-gd php7.4-mysql php7.4-intl php7.4-sqlite3 php7.4-soap php7.4-bcmath php7.4-memcached php7.4-redis nginx nodejs rlwrap git dos2unix memcached mysql-client default-jre htop yarn unzip dh-autoreconf beanstalkd mysql-server redis-server`
- `sudo npm install gulp-cli -g`
- `touch ~/.hushlogin`
- Copy your private key to the `~/.ssh/` directory

# nginx
Nginx needs to be configured. This depends on how you want to setup your vhosts. 
We've included our '/etc/nginx' folder (excluding the SSL certificates) in this repository as reference.
You can copy this directory to your /etc/nginx folder. The easist is running `cd /etc/nginx && explorer.exe .` and copy the files from that folder over.

# MySQL
We just need to set the root password to 'secret'. The other default configuration is fine for your usecase:
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
        "laravel/installer": "~1.1",
        "enflow/crane": "dev-master"
    }
}
```

Run `composer global update` to install those global dependencies.
    
# SSL certificates
- Install https://brew.sh/ (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`)
- Install https://github.com/FiloSottile/mkcert (`/home/linuxbrew/.linuxbrew/bin/brew install mkcert`)
- Install mkcert `/home/linuxbrew/.linuxbrew/bin/mkcert -install`
- Create certificate. We ran the following, but depends on your subdomains/nginx configuration etc.
`mkcert '*.enflow.test' '*.client.test' '*.crewplanner.client.test' '*.concept.test' '*.foundation.test' '*.private.test'`
- Move generated certificate and key to `/etc/dev-ssl/cert.pem` & '/etc/dev-ssl/key.pem'

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
- Go to File -> Open Acrylic Configuration
- Paste the following at the end of the file:
```
127.0.0.1 *.foundation.test
127.0.0.1 *.enflow.test
127.0.0.1 *.client.test
127.0.0.1 *.private.test
```
- Edit your network device (LAN & WiFi if applicable) to use the `127.0.0.1` as primary DNS server and `1.1.1.1` as secondary DNS server as fallback. More info about this can be found here: https://mayakron.altervista.org/support/acrylic/Windows10Configuration.htm


