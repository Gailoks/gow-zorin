FROM ubuntu:24.10 AS bwrap-builder

ENV DEBIAN_FRONTEND=non-interactive
WORKDIR /root
COPY ignore_capabilities.patch /root/
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends git meson ca-certificates dpkg-dev && \
    git clone https://github.com/containers/bubblewrap && \
    cd bubblewrap && \
    ./ci/builddeps.sh && \
    patch -p1 < ../ignore_capabilities.patch && \
    meson _builddir && \
    meson compile -C _builddir

######################################

FROM ubuntu:22.04

ENV \
    PUID=1000 \
    PGID=1000 \
    UMASK=000 \
    UNAME="retro" \
    HOME="/home/retro" \
    TZ="Europe/Moscow" \
    DEBIAN_FRONTEND=noninteractive \
    NEEDRESTART_SUSPEND=1 \
    LANG=ru_RU.UTF-8 \
    LANGUAGE=ru_RU:en_US \
    LC_ALL=ru_RU.UTF-8 \
    XDG_RUNTIME_DIR=/tmp/.X11-unix

COPY packages .
COPY --from=bwrap-builder --chmod=755 /root/bubblewrap/_builddir/bwrap /usr/bin/bwrap

RUN <<_INSTALL_PACKAGES
set -e

# Get gosu
mv gosu /usr/bin/gosu
chmod +x /usr/bin/gosu

# Add repositories
dpkg --add-architecture i386
apt update
apt install -y software-properties-common
add-apt-repository ppa:zorinos/stable
add-apt-repository ppa:zorinos/patches
add-apt-repository ppa:zorinos/apps
add-apt-repository ppa:kisak/kisak-mesa
add-apt-repository multiverse
add-apt-repository universe
apt update
apt-get install -y zorin-os-keyring


# Core deps
apt install -y --no-install-recommends \
    xwayland \
    libglx-mesa0 libgl1 \
    systemd \
    libnss3 \
    wget \
    curl \
    ca-certificates \
    gnupg2 \
    dbus-x11 \
    dbus-user-session \
    flatpak \
    sudo \
    locales \
    xdg-utils \
    libfreetype6:i386 \
    libvulkan1 \
    libvulkan1:i386 \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    libasound2-plugins:i386 \
    libsdl2-2.0-0:i386 \
    libdbus-1-3:i386 \
    libsqlite3-0:i386 \
    winetricks \
    zenity \
    libnotify4 \
    xdg-utils \
    libsecret-1-0 \
    curl \
    unzip \
    p7zip-full \
    cabextract \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    gstreamer1.0-plugins-base:i386 gstreamer1.0-plugins-good:i386 gstreamer1.0-plugins-bad:i386 gstreamer1.0-plugins-ugly:i386 gstreamer1.0-libav:i386 \
    tar \
    libx11-6 libxext6 libxfixes3 libxdamage1 \
    libxshmfence1 libxxf86vm1 \
    libdrm2 libgbm1 libpixman-1-0 \
    gnome-software-plugin-flatpak \
    ca-certificates \
    xz-utils \
    libgbm1 libgles2 libegl1 libgl1-mesa-dri \
    libnvidia-egl-wayland1 libnvidia-egl-gbm1 \
    steam-installer dbus-daemon dbus-system-bus-common dbus-session-bus-common \
    libxext6 \
    libvulkan-dev \
    vulkan-tools \
    zip unzip p7zip-full \
    gnome-software gnome-software-plugin-flatpak \
    sway zorin-os-desktop zorin-appearance 


echo exit 0 > /usr/sbin/policy-rc.d

# Get heroic game launcher
#wget -O heroic.deb https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.18.1/Heroic-2.18.1-linux-amd64.deb
dpkg -i heroic.deb
rm heroic.deb

# Get MangoHud
#wget -O MangoHud.tar.gz https://github.com/flightlessmango/MangoHud/releases/download/v0.8.1/MangoHud-0.8.1.r0.gfea4292.tar.gz
tar xf MangoHud.tar.gz
cd MangoHud
tar xf MangoHud-package.tar
chmod +x ./mangohud-setup.sh && ./mangohud-setup.sh install
rm -rf /MangoHud
rm /MangoHud.tar.gz

#wget --progress=dot:giga \
#    -O /usr/bin/gosu \
#    "https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64"

# Cleanup
apt-get clean
rm -rf /var/lib/apt/lists/*

# Locale
locale-gen en_US.UTF-8
locale-gen ru_RU.UTF-8
update-locale LANG=ru_RU.UTF-8

for file in $(find /usr -type f -iname "*login1*"); do mv -v $file "$file.back"; done
chmod u+s /usr/bin/bwrap

_INSTALL_PACKAGES

WORKDIR /

COPY entrypoint.sh .
COPY --chmod=700 ensure-groups.sh .
COPY --chmod=700 setup-user.sh .
COPY --chmod=700 setup-devices.sh .
COPY --chmod=700 setup-nvidia.sh .

ENTRYPOINT ["/entrypoint.sh"]
