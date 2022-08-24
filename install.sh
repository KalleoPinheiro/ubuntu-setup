echo '########## <updating and upgrade> ##########'
sudo apt-get update
sudo dpkg --configure -a
sudo apt-get upgrade -y

echo '########## <updating snap> ##########'
sudo snap refresh

echo '########## <creating a Project folder> ##########'
mkdir -p ~/Projects

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

echo '########## <installing chrome> ##########'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

rm -rf google-chrome-stable_current_amd64.deb

echo '########## <installing terminator> ##########'
sudo apt-get update
sudo apt-get install terminator -y -f

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
DOCKER_COMPOSE_LATEST=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/')
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

echo '########## <installing theme> ##########'
sudo apt install fonts-firacode -y

echo '########## <installing zsh spaceship> ##########'
sudo git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH/themes/spaceship-prompt"
sudo ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"
sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="spaceship"/g' ~/.zshrc
source ~/.zshrc

cat <<EOF >>~/.zshrc

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
EOF
source ~/.zshrc

echo '########## <installing zsh zinit> ##########'
sh -c "$(curl -fsSL https://git.io/zinit-install)"
zinit self-update

cat <<EOF >>~/.zshrc
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
EOF

echo '########## <adding alias to zsh> ##########'
cat <<EOF >>~/.zshrc

alias refresh="sudo apt update; sudo apt -y upgrade; sudo apt -y dist-upgrade; sudo apt -y autoremove; sudo apt clean
alias projects="cd ~/Projects"
EOF

echo '########## <installing code> ##########'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
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

echo '########## <customizing terminator> ##########'
cat <<EOF >>~/.config/terminator/config
[global_config]
  geometry_hinting = True
  always_split_with_profile = True
  title_transmit_bg_color = "#0071c8"
[keybindings]
  new_tab = <Primary>t
  split_horiz = <Primary>e
  split_vert = <Primary>d
  close_term = <Primary>w
  paste = <Primary>v
  close_window = <Primary>q
  switch_to_tab_1 = <Primary>1
  switch_to_tab_2 = <Primary>2
  switch_to_tab_3 = <Primary>3
  switch_to_tab_4 = <Primary>4
  switch_to_tab_5 = <Primary>5
  switch_to_tab_6 = <Primary>6
  switch_to_tab_10 = <Primary>0
  new_window = <Primary>i
[profiles]
  [[default]]
    cursor_color = "#aaaaaa"
  [[Dracula]]
    background_color = "#1e1f29"
    background_darkness = 0.7
    background_type = transparent
    cursor_color = "#bbbbbb"
    font = Fira Code weight=453 10
    foreground_color = "#f8f8f2"
    scrollback_infinite = True
    palette = "#000000:#ff5555:#50fa7b:#f1fa8c:#bd93f9:#ff79c6:#8be9fd:#bbbbbb:#555555:#ff5555:#50fa7b:#f1fa8c:#bd93f9:#ff79c6:#8be9fd:#ffffff"
    use_system_font = False
    copy_on_selection = True
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      type = Terminal
      profile = Dracula
    [[[window0]]]
      parent = ""
      type = Window
      profile = Dracula
      size = 1280, 720
[plugins]
EOF

echo '########## <installing nvm> ##########'
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
) && \. "$NVM_DIR/nvm.sh"

cat <<EOF >>~/.zshrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF

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

echo '########## <installing gnome tweeks> ##########'
sudo apt install gnome-tweaks
gsettings set org.gnome.mutter center-new-windows true

echo '########## <installing xclip> ##########'
sudo apt-get install xclip

echo '########## <installing ulauncher> ##########'
sudo add-apt-repository ppa:agornostal/ulauncher
sudo apt update
sudo apt install ulauncher
sudo apt install wmctrl

echo '########## <set favortie apps> ##########'
dconf write /org/gnome/shell/favorite-apps "[ \
  'org.gnome.Nautilus.desktop', \
  'google-chrome.desktop', \
  'insomnia.desktop', \
  'spotify.desktop', \
  'code.desktop' \,
  'terminator.desktop' \,
  'bitwarden.desktop' \
]"

echo '########## <enabling workspaces for both screens> ##########'
sudo apt install dconf-editor
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
# gsettings reset org.gnome.shell.extensions.dash-to-dock dash-max-icon-size

echo '########## <configure git alias> ##########'
git config --global fetch.prune true
git config --global help.autocorrect 1
git config --global alias.l "!git log --pretty=format:'%C(blue)%h%C(red)%d %C(white) %s %C(cyan)[%cn] %C(green)%cr'"
git config --global alias.c "!git add . && git commit"
git config --global alias.s "!git status -sb"
git config --global alias.branches "!git branch -a"
git config --global alias.amend "!git add . && git commit --amend --no-verify"
git config --global alias.fetch "!git fetch --all"
git config --global alias.backup "!git ls-files --others --exclude-standard -z | xargs -0 tar rvf ~/backup-untracked.zip"
git config --global alias.clean-merged "!git branch --merged develop | grep -v "develop" | xargs -n 1 git branch -d"

echo '########## <installing npm global modules> ##########'
npm install -g yarn
npm install -g npm-check-updates
npm install -g ntl
npm install -g npkill

source ~/.zshrc

echo "########## --> That’s all folks! <-- ##########"
echo "Restart computer for you? (y/n)"
read restart_computer
if echo "$restart_computer" | grep -iq "^y"; then
  sudo shutdown -r 0
else
  echo "Okay. Good work! :)"
fi
