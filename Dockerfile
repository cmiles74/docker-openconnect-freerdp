from alpine:edge

# setup our custom path
env PATH="/developer/bin:${PATH}"

# add repositories
run echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
run echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# update packages
run apk update

# update and install packages
run apk update
run apk upgrade
run apk add openconnect@testing midori@community freerdp@community bash tmux sudo xrandr openssh xsel@testing

# create our developer user
workdir /root
run addgroup --gid 1000 developer
run adduser developer -G developer --uid 1000 --shell /bin/bash --system --home /developer --shell /bin/bash
run echo "developer ALL=(ALL) ALL"
copy /developer /developer
run mv /etc/vpnc/vpnc-script /etc/vpnc/vpnc-script.bak
run mv /developer/vpnc-script /etc/vpnc

# custom scripts
copy /custom-bin /developer/bin

# set permissions
run chmod +x /developer/bin/*
run chown -R developer:developer /developer
run echo "%developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# cleanup aur packages
user root
workdir /developer

# start a terminal
user developer
entrypoint ["tmux", "-u"]

