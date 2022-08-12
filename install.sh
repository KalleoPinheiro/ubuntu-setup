echo '########## <updating and upgrade> ##########'
sudo apt-get update 
sudo dpkg --configure -a
sudo apt-get upgrade -y

echo '########## <updating snap> ##########'
sudo snap refresh

sudo bash -c 'cat <<EOF > /usr/local/bin/refresh.sh
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt -y autoremove
sudo apt-get clean
EOF'
sudo chmod +x /usr/local/bin/refresh.sh

mkdir -p ~/projects

echo '########## <installing curl> ##########'
sudo apt install curl -y -f
curl -V

echo '########## <installing git> ##########'
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt install git -y -f
git --version

echo 'What name do you want to use in GIT user.name?'
read -r git_config_user_name
git config --global user.name "$git_config_user_name"

echo 'What email do you want to use in GIT user.email?'
read -r git_config_user_email
git config --global user.email "$git_config_user_email"

echo '########## <generating a SSH Key> ##########'
ssh-keygen -t rsa -b 4096 -C "$git_config_user_email"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'enabling workspaces for both screens' 
gsettings set org.gnome.mutter workspaces-only-on-primary false

echo '########## <installing chrome> ##########'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

rm -rf google-chrome-stable_current_amd64.deb

echo '########## <installing terminator> ##########'
sudo apt-get update
sudo apt-get install terminator -y  -f

echo '########## <installing docker> ##########'
sudo apt-get remove docker docker-engine docker.io -y
sudo apt install docker.io -y -f
sudo systemctl enable --now docker
sudo usermod -aG docker ${USER}
sudo systemctl start docker
sudo systemctl enable docker
docker --version

sudo chmod 777 /var/run/docker.sock

echo '########## <installing docker-compose> ##########'
DOCKER_COMPOSE_LATEST=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" \
   | grep '"tag_name":' \
   | sed -E 's/.*"([^"]+)".*/\1/')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_LATEST}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo '########## <installing ctop> ##########'
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
sudo apt update
sudo apt install docker-ctop

echo '########## <installing spotify> ##########'
sudo snap install spotify

echo '########## <installing vlc player> ##########'
sudo snap install vlc

echo '########## <installing insomnia> ##########'
sudo snap install insomnia

echo '########## <installing peek> ##########'
sudo add-apt-repository ppa:peek-developers/stable -y
sudo apt-get update
sudo apt-get install peek -y

echo '########## <installing chrome-gnome-shell> ##########'
sudo apt-get install chrome-gnome-shell

echo '########## <installing tree> ##########'
sudo apt-get install tree -y

echo '########## <installing beekeeper-studio> ##########'
sudo snap install beekeeper-studio

echo '########## <installing zsh> ##########'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

echo '########## <installing autosuggestions> ##########' 
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

echo '########## <installing theme> ##########'
sudo apt install fonts-firacode -y
wget -O ~/.oh-my-zsh/themes/node.zsh-theme https://raw.githubusercontent.com/skuridin/oh-my-zsh-node-theme/master/node.zsh-theme 
sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="node"/g' ~/.zshrc

echo '########## <installing meet franz> ##########'
wget https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
sudo dpkg -i franz.debchristian-kohler.path-intellisense
sudo apt-get install -y -f 

echo '########## <installing zsh spaceship> ##########'
sudo git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH/themes/spaceship-prompt"
sudo ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"
source ~/.bashrc

echo '########## <installing zsh zplugin> ##########'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

source ~/.bashrc

echo '########## <installing code> ##########'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y

echo '########## <installing extensions> ##########'
code --install-extension christian-kohler.path-intellisense
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension naumovs.color-highlight
code --install-extension dracula-theme.theme-dracula
code --install-extension esbenp.prettier-vscode
code --install-extension foxundermoon.shell-format
code --install-extension waderyan.gitblame
code --install-extension yzhang.markdown-all-in-one
code --install-extension formulahendry.auto-close-tag
code --install-extension donjayamanne.githistory
code --install-extension visualstudioexptteam.vscodeintelli
code --install-extension natqe.reload
code --install-extension visualstudioexptteam.intellicode-api-usage-examples
code --install-extension eamodio.gitlens
code --install-extension editorconfig.editorconfig
code --install-extension formulahendry.auto-rename-tag
code --install-extension aaron-bond.better-comments
code --install-extension mikestead.dotenv
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension pkief.material-icon-theme
code --install-extension pulkitgangwar.nextjs-snippets
code --install-extension styled-components.vscode-styled-components

echo '########## <installing bitwarden> ##########'
sudo snap install bitwarden

echo '########## <installing terminator> ##########'
sudo apt-get update
sudo apt-get install terminator -y

echo 'adding dracula theme' 
cat <<EOF >  ~/.config/terminator/config
[global_config]
  title_transmit_bg_color = "#ad7fa8"
[keybindings]
  close_term = <Primary>w
  close_window = <Primary>q
  new_tab = <Primary>t
  new_window = <Primary>i
  paste = <Primary>v
  split_horiz = <Primary>e
  split_vert = <Primary>d
  switch_to_tab_1 = <Primary>1
  switch_to_tab_10 = <Primary>0
  switch_to_tab_2 = <Primary>2
  switch_to_tab_3 = <Primary>3
  switch_to_tab_4 = <Primary>4
  switch_to_tab_5 = <Primary>5
  switch_to_tab_6 = <Primary>6
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      type = Terminal
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    cursor_color = "#aaaaaa"
EOF


cat <<EOF >>  ~/.config/terminator/config
[[Dracula]]
    background_color = "#1e1f29"
    background_darkness = 0.88
    background_type = transparent
    copy_on_selection = True
    cursor_color = "#bbbbbb"
    foreground_color = "#f8f8f2"
    palette = "#000000:#ff5555:#50fa7b:#f1fa8c:#bd93f9:#ff79c6:#8be9fd:#bbbbbb:#555555:#ff5555:#50fa7b:#f1fa8c:#bd93f9:#ff79c6:#8be9fd:#ffffff"
    scrollback_infinite = True
EOF

echo '########## <installing nvm> ##########' 
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

export NVM_DIR="$HOME/.nvm" && (
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.zshrc
nvm --version
nvm install 14
nvm alias default 14
node --version
npm --version

echo '########## <installing awscli> ##########' 
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

echo '########## <installing ulauncher> ##########' 
sudo add-apt-repository ppa:agornostal/ulauncher
sudo apt update
sudo apt install ulauncher

echo '########## <set favortie apps> ##########'
dconf write /org/gnome/shell/favorite-apps "[ \
  'org.gnome.Nautilus.desktop', \
  'google-chrome.desktop', \
  'insomnia.desktop', \
  'spotify.desktop', \
  'code.desktop' \
]" 

echo '########## <configure git alias> ##########'
git config --global alias.l "!git log --pretty=format:'%C(blue)%h%C(red)%d %C(white) %s %C(cyan)[%cn] %C(green)%cr'"
git config --global alias.c "!git add . && git commit"
git config --global alias.s "!git status -sb"
git config --global alias.branches "!git branch -a"
git config --global alias.amend = !git add . && git commit --amend --no-edit

echo '########## <installing npm global modules> ##########'
npm install --global yarn

echo "########## --> That’s all folks! <-- ##########"
echo "Restart computer for you? (y/n)"
read restart_computer
if echo "$restart_computer" | grep -iq "^y" ;then
	sudo shutdown -r 0
else
	echo "Okay. Good work! :)"
fi