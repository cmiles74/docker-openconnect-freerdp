from dock0/arch:latest

# setup our custom path
env PATH="/developer/bin:${PATH}"

# install X Org
run pacman -Syqu --noconfirm base-devel binutils tmux bash man fish git openssh wget curl rxvt-unicode vi xorg-xrdb xorg-fonts-encodings xorg-font-utils xorg-xrandr bdf-unifont firefox-developer-edition

# install openconnect
run pacman -Syqu --noconfirm openconnect

# install freerdp
run pacman -Syqu --noconfirm freerdp

# create our developer user
workdir /root
run groupadd -r developer -g 1000
run useradd -u 1000 -r -g developer -d /developer -c "Software Developer" developer
copy /developer /developer

# custom scripts
copy /custom-bin /developer/bin

# set permissions
run chmod +x /developer/bin/*
run chown -R developer:developer /developer
run echo "%developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# build hack aur package
user developer
workdir /developer
run mkdir aur
run git clone https://aur.archlinux.org/ttf-hack.git aur/ttf-hack
workdir /developer/aur/ttf-hack
run makepkg
user root
run pacman -U --noconfirm *xz

# cleanup aur packages
user root
workdir /developer
run rm -rf aur

# volume used for mounting project files
# volume ["/project"]
# copy project /project
# workdir /project

# start a terminal
user developer
entrypoint ["tmux", "-u"]
