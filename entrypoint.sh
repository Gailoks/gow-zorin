#!/bin/bash -e

/setup-user.sh
/setup-devices.sh
/setup-nvidia.sh
/setup-config.sh

mkdir -p /tmp/sockets/
chown $UNAME:$UNAME -R /tmp/sockets/
chmod 0700 -R /tmp/sockets/
chmod +t -R /tmp/sockets
chown $UNAME:$UNAME -R /home/$UNAME
mkdir -p -m 777 /var/run/dbus
mkdir -p -m 1777 /tmp/.X11-unix
chown root:root /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
echo ">> Creating log directory /logs"
mkdir -p /logs
chmod 777 -R /logs
echo ">> Starting dbus"
service dbus start &> /logs/dbus.log

if [ -d /custom-scripts ]; then
    echo ">> Running custom scripts in: /custom-scripts"
    
    # Проходим по всем файлам в папке /custom-scripts
    for script in /custom-scripts/*; do
        if [ -f "$script" ]; then
            echo ">> Running script: $script"
            chmod +x "$script"
            "$script" || echo "Script $script exited with error $?"
        fi
    done
fi

exec gosu "${UNAME}" bash -c '
  echo ">> Create users dirs"
  xdg-user-dirs-update &> /logs/xdg.log

  export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/$UNAME/.local/share/flatpak/exports/share:/usr/local/share/:/usr/share/

  # environement variables to ensure apps integrate well with our wm or de, https://wiki.archlinux.org/title/Xdg-utils#Environment_variables
  export XDG_CURRENT_DESKTOP=zorin:GNOME
  export DE=zorin
  export DESKTOP_SESSION=zorin
  export GNOME_SHELL_SESSION_MODE="zorin"
  export XDG_SESSION_TYPE=x11

  # Various envs to help with apps compability
  export XDG_SESSION_CLASS="user"
  export _JAVA_AWT_WM_NONREPARENTING=1
  export GDK_BACKEND=x11
  export MOZ_ENABLE_WAYLAND=0
  export QT_QPA_PLATFORM="xcb"
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_ENABLE_HIGHDPI_SCALING=1

  ORIGINAL_PATH="$HOME/.config/dconf/user"
  BACKUP_PATH="$HOME/.config/dconf/user.bak"

  if [ -f "$ORIGINAL_PATH" ]; then
    if [ -f "$BACKUP_PATH" ]; then
      echo ">> Restoring settings. "
      cp "$BACKUP_PATH" "$ORIGINAL_PATH"
    else
      echo ">> Copying settings. "
      cp "$ORIGINAL_PATH" "$BACKUP_PATH"
    fi
  else
    echo ">> Nothing to do."
  fi

  echo ">> Setup mangohud"
  export MANGOHUD=${MANGOHUD:-1}

  gsettings set org.gnome.desktop.interface scaling-factor 1

  echo ">> Launching Xwayland"
  export DISPLAY=:10
  mkdir -p $HOME/.config/sway
  echo "default_border none" > $HOME/.config/sway/config
  #echo "xwayland disable" >> $HOME/.config/sway/config
  echo "output * resolution ${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT}@${GAMESCOPE_REFRESH}Hz position 0,0" >> $HOME/.config/sway/config
  echo "exec  Xwayland :10 -fakescreenfps 180 & DISPLAY=:10 /usr/bin/gnome-session" >> $HOME/.config/sway/config
  export $(dbus-launch)

  echo ">> Setting up flatpak"
  flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /logs/flatpak.log
  flatpak override --user --nosocket=wayland &>> /logs/flatpak.log
  echo ">> Starting $DE"
  dbus-run-session -- sway --unsupported-gpu
'
