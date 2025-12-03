# gow-zorin: Zorin OS for Gaming - A Complete Guide

This guide provides a complete description of using gow-zorin, a pre-configured Zorin OS environment optimized for gaming. It covers the project description, configuration details, deployment instructions, and troubleshooting tips.

## Contents

*   [Introduction](#introduction)
*   [Description](#description)
*   [Configuration](#configuration)
*   [Build](#build)
*   [Customization](#customization)
*   [Troubleshooting](#troubleshooting)

## Introduction

gow-zorin aims to provide a ready-to-use Zorin OS environment, eliminating the complexities of manual gaming setup. This configuration utilizes Docker containerization for portability and ease of management. This guide assumes a basic understanding of Docker concepts.

## Description

gow-zorin provides a fully functional Zorin OS environment with pre-installed tools and optimized settings for a seamless gaming experience. It offers a familiar Windows-like interface while leveraging the power and flexibility of Zorin OS. Key features include:

*   **Pre-configured Environment:** Eliminates manual setup for gaming.
*   **Gaming Support:** Includes Steam, Heroic Game Launcher, and Mango HUD, pre-installed.
*   **Optimized Performance:** Settings are geared towards smooth gameplay and responsiveness.
*   **Customizability:** Provides options for custom scripts and configuration adjustments.

## Configuration

This section contains information about the configuration required to deploy the gow-zorin environment. The main configuration is presented in `config.toml` format below. **Carefully review each setting to ensure compatibility with your system and desired configuration.**

**Example config**
```toml
[[profiles]]
id = 'moonlight-profile-id'


[[profiles.apps]]
icon_png_path = 'https://www.svgrepo.com/show/354605/zorin-os.svg'
start_virtual_compositor = true
title = 'Zorin'


[profiles.apps.runner]
base_create_json = '''{
"HostConfig": {
"IpcMode": "host",
"CapAdd": ["SYS_ADMIN", "SYS_NICE", "SYS_PTRACE", "NET_RAW", "MKNOD", "NET_ADMIN"],
"SecurityOpt": ["seccomp=unconfined", "apparmor=unconfined"],
"Ulimits": [{"Name":"nofile", "Hard":524288, "Soft":10240}],
"Privileged": false,
"DeviceCgroupRules": ["c 13:* rmw", "c 244:* rmw"]
}
}'''


devices = []
env = [ 'LC_ALL=ru_RU.UTF-8', 'GOW_REQUIRED_DEVICES=/dev/input/* /dev/dri/* /dev/nvidia*', 'XKB_DEFAULT_LAYOUT=us,ru' ]
image = 'gailoks/gow-zorin:zorin-18'
mounts = ['/games/steam/:/home/retro/.steam/debian-installation/steamapps:rw','/games/heroic:/home/retro/Games/Heroic:rw' ]
name = 'WolfZorin'
ports = []
type = 'docker'
```

## Build

To build the Docker image, use the following command:

```
docker build -t gailoks/gow-zorin:latest .
```


## Customization

### Mounts

You can share installed games between users using special mounts.

For Steam:

```
'/host/path/SteamLibrary/:/home/retro/.steam/debian-installation/steamapps:rw'
```

Note:  The user folder must be located on the same drive as your Steam library. If not, you're likely to have issues with free space identification (which will use your home folder's available space).

For Heroic Game Launcher:

```
'/host/path/Games:/home/retro/Games/Heroic:rw'
```

Note: Some games may report the Docker overlay's space as their available space. In such cases, you should manually delete `/home/retro/Prefixes/default/<your-game>/dosdevices/z:` and replace it with a symlink to `/home/retro/Games`.  This should fix the problem.

For custom scripts:

```
'/host/path/custom-scripts:/custom-scripts:ro'
```

Note: These are executed *before* the desktop environment starts.  If you need more detailed information, refer to [this](https://github.com/Gailoks/gow-zorin/blob/zorin-18/entrypoint.sh).

### Custom environment variables

*   **TZ:** Set the Time Zone. See [Time Zone Format](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
*   **XKB_DEFAULT_LAYOUT:** Set the keyboard layout. Requires extra setup in Zorin settings. More information [here](https://wiki.archlinux.org/title/Xorg/keyboard_configuration).
*   **LC_ALL:** Set the Locale. Works partially. For extra compatibility, download additional localization packages for Zorin OS. More information [here](https://wiki.archlinux.org/title/Locale).

### Configs

*   **MangoHUD:** Edit the `/home/retro/.config/MangoHUD/MangoHUD.conf` file. You can do this using MangoJuice (installable from the Gnome Software Center).

## Pros

*   **Ease of Use:** The pre-configured environment saves considerable time on setup.
*   **Gaming Readiness:** All necessary gaming tools are already installed.
*   **Optimized Performance:** Configurations are geared towards smooth gameplay and responsiveness.
*   **Customizability:** Ability to run custom scripts.

## Cons

*   **Resource Intensity:** Zorin OS, although lightweight in its own right, requires reasonable system resources.

## Troubleshooting

*   **Application Compatibility:** Some applications may require additional configuration or troubleshooting.
*   **Log Errors:** Check the `/logs` directory for log files (dbus.log, xdg.log, flatpak.log) to identify errors.
*   **Custom Script Errors:** Check the `/logs` directory for errors when running a custom script.
*   **Configuration Reset:** Deleting `.config/dconf/user.bak` will allow you to save new desktop settings (theme, wallpaper, etc.).
*	**Displayed screen refresh rate** Gnome says that the display is 60Hz no matter how you change your fps in moonlight. It is just a number(I don't know how to edit it).
---

# gow-zorin: Zorin OS для Гейминга - Полное Руководство

Это руководство предоставляет полное описание использования gow-zorin, предустановленной среды Zorin OS, оптимизированной для игр.  Оно охватывает описание проекта, сведения о конфигурации, инструкции по развертыванию и рекомендации по устранению неполадок.

## Оглавление

*   [Введение](#введение)
*   [Описание](#описание)
*   [Конфигурация](#конфигурация)
*   [Сборка](#сборка)
*   [Настройка](#настройка)
*   [Устранение неполадок](#устранение-неполадок)

## Введение

gow-zorin предоставляет готовое к использованию окружение Zorin OS, оптимизированное для игр и избавляющее от необходимости ручной настройки.  Эта конфигурация использует контейнеризацию Docker для обеспечения переносимости и простоты управления.  В этом руководстве предполагается базовое понимание концепций Docker.

## Описание

gow-zorin предоставляет полностью функциональную среду Zorin OS с предустановленными инструментами и оптимизированными настройками для комфортного игрового процесса.  Она предлагает привычный интерфейс, похожий на Windows, при этом используя мощность и гибкость Zorin OS.  Ключевые особенности:

*   **Предварительно настроенная среда:** Исключает необходимость ручной настройки для игр.
*   **Поддержка игр:** Включены Steam, Heroic Game Launcher и Mango HUD.
*   **Оптимизированная производительность:** Настройки направлены на плавную игру и отзывчивость.
*   **Настраиваемость:** Предоставляет возможности для запуска пользовательских скриптов и изменения конфигурации.

## Конфигурация

Этот раздел содержит информацию о необходимой конфигурации для развертывания среды gow-zorin.  Основная конфигурация представлена в формате `config.toml` ниже.  **Внимательно изучите каждую настройку, чтобы обеспечить совместимость с вашей системой и желаемой конфигурацией.**

**Пример конфигурации**
```toml
[[profiles]]
id = 'moonlight-profile-id'


[[profiles.apps]]
icon_png_path = 'https://www.svgrepo.com/show/354605/zorin-os.svg'
start_virtual_compositor = true
title = 'Zorin'


[profiles.apps.runner]
base_create_json = '''{
"HostConfig": {
"IpcMode": "host",
"CapAdd": ["SYS_ADMIN", "SYS_NICE", "SYS_PTRACE", "NET_RAW", "MKNOD", "NET_ADMIN"],
"SecurityOpt": ["seccomp=unconfined", "apparmor=unconfined"],
"Ulimits": [{"Name":"nofile", "Hard":524288, "Soft":10240}],
"Privileged": false,
"DeviceCgroupRules": ["c 13:* rmw", "c 244:* rmw"]
}
}'''


devices = []
env = [ 'LC_ALL=ru_RU.UTF-8', 'GOW_REQUIRED_DEVICES=/dev/input/* /dev/dri/* /dev/nvidia*', 'XKB_DEFAULT_LAYOUT=us,ru' ]
image = 'gailoks/gow-zorin:zorin-18'
mounts = ['/games/steam/:/home/retro/.steam/debian-installation/steamapps:rw','/games/heroic:/home/retro/Games/Heroic:rw' ]
name = 'WolfZorin'
ports = []
type = 'docker'
```

## Сборка

Чтобы собрать образ Docker, используйте следующую команду:

```
docker build -t gailoks/gow-zorin:latest .
```

## Настройка

Этот раздел содержит информацию о настройке для развертывания среды gow-zorin.

### Монтирование

Вы можете совместно использовать установленные игры между пользователями с помощью специальных монтирований.

Для Steam:

```
'/host/path/SteamLibrary/:/home/retro/.steam/debian-installation/steamapps:rw'
```

Обратите внимание: Папка пользователя должна находиться на том же диске, что и ваша библиотека Steam. Если это не так, у вас, вероятно, возникнут проблемы с идентификацией свободного места (которое будет использовать доступное место на вашем домашнем диске).

Для Heroic Game Launcher:

```
'/host/path/Games:/home/retro/Games/Heroic:rw'
```

Обратите внимание: Для некоторых игр может отображаться пространство наложения Docker как доступное место. В таких случаях вам следует вручную удалить `/home/retro/Prefixes/default/<your-game>/dosdevices/z:` и заменить его символической ссылкой на `/home/retro/Games`. Это должно решить проблему.

Для пользовательских скриптов:

```
'/host/path/custom-scripts:/custom-scripts:ro'
```

Обратите внимание: Они выполняются *до* запуска среды рабочего стола. Если вам нужна более подробная информация, обратитесь к [этому](https://github.com/Gailoks/gow-zorin/blob/zorin-18/entrypoint.sh).

### Пользовательские переменные окружения

*   **TZ:** Установите часовой пояс. См. [Формат часовых поясов](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
*   **XKB_DEFAULT_LAYOUT:** Установите раскладку клавиатуры. Требуется дополнительная настройка в настройках Zorin. Подробная информация [здесь](https://wiki.archlinux.org/title/Xorg/keyboard_configuration).
*   **LC_ALL:** Установите локаль. Работает частично. Для большей совместимости скачайте дополнительные пакеты локализации для Zorin OS. Подробная информация [здесь](https://wiki.archlinux.org/title/Locale).

### Конфигурации

*   **MangoHUD:** Отредактируйте файл `/home/retro/.config/MangoHUD/MangoHUD.conf`. Вы можете сделать это с помощью MangoJuice (доступен для установки из Gnome Software Center).

## Плюсы

*   **Простота использования:** Предварительно настроенная среда экономит значительное время на настройку.
*   **Готовность к играм:** Все необходимые инструменты для игр уже установлены.
*   **Оптимизированная производительность:** Конфигурации направлены на плавную игру и отзывчивость.
*   **Настраиваемость:** Возможность запуска пользовательских скриптов.

## Минусы

*   **Интенсивность ресурсов:** Zorin OS, хотя и легкая в своем роде, требует разумных системных ресурсов.

## Устранение неполадок

*   **Совместимость приложений:** Некоторые приложения могут потребовать дополнительной настройки или устранения неполадок.
*   **Ошибки в журналах:** Проверьте каталог `/logs` на наличие файлов журналов (`dbus.log`, `xdg.log`, `flatpak.log`) для выявления ошибок.
*   **Ошибки пользовательских скриптов:** Проверьте каталог `/logs` на наличие ошибок при выполнении пользовательского скрипта.
*   **Сброс конфигурации:** Удаление `.config/dconf/user.bak` позволит сохранить новые настройки рабочего стола (тему, обои и т.д.).
*	**Отображаемая частота кадров:** Настройки gnome не зависимо от настройки moonlight всегда отображают 60 кадров. Это всего лишь число(Я не нашел где его можно изменить).
