# gow-zorin: Zorin OS for Gaming - A Complete Guide

This guide provides a complete description of using gow-zorin, a pre-configured Zorin OS environment optimized for gaming. It covers project description, configuration details, deployment instructions, and troubleshooting tips.

## Contents

*   [Introduction](#introduction)
*   [Description](#description)
*   [Configuration](#configuration)
*   [Build](#build)
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

```toml
[[apps]]
icon_png_path = 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%2Fid%2FOIP.-GsZ83B2UfwcfGYxPs7xKwHaHa%3Fpid%3DApi&f=1&ipt=f5462269e1ce601ba074dd3cfd09c2bb6606850c4f262fe46db1988fe993ed9e'
start_virtual_compositor = true
title = 'Zorin'
    [apps.runner]
    base_create_json = '''{
  "HostConfig": {
    "IpcMode": "host",
    "CapAdd": ["SYS_ADMIN", "SYS_NICE", "SYS_PTRACE", "NET_RAW", "MKNOD", "NET_ADMIN"],
    "SecurityOpt": ["seccomp=unconfined", "apparmor=unconfined"],
    "Ulimits": [{"Name":"nofile", "Hard":524288, "Soft":10240}],
    "Privileged": true,
    "DeviceCgroupRules": ["c 13:* rmw", "c 244:* rmw"]
  }
}
'''
    devices = []
    env = [ 'LC_ALL=ru_RU.UTF-8', 'GOW_REQUIRED_DEVICES=/dev/input/* /dev/dri/* /dev/nvidia*', 'XKB_DEFAULT_LAYOUT=us,ru' ]
    image = 'gailoks/gow-zorin:latest'
    mounts = [ ]
    name = 'WolfZorin'
    ports = []
    type = 'docker'
```

## Build

To build the Docker image, use the following command:  

```
docker build -t gailoks/gow-zorin:latest .
```

## Pros 

*    **Ease of Use**: The pre-configured environment saves considerable time on setup.
*    **Gaming Readiness**: All necessary gaming tools are already installed.
*    **Optimized** Performance: Configurations are geared towards smooth gameplay and responsiveness.
*    **Customizability**: Ability to run custom scripts.
     

## Cons 

*    **Slow Startup**: Any launch will take longer than launching a lighter DE.
*    **Resource Intensity**: Zorin OS, although lightweight in its own right, requires reasonable system resources.
     

## Troubleshooting 

*    **Application Compatibility**: Some applications may require additional configuration or troubleshooting.
*    **Log Errors**: Check the /logs directory for log files (dbus.log, xdg.log, flatpak.log) to identify errors.
*    **Custom Script** Errors: Check the /logs directory for errors when running a custom script.
*    **Proton Compatibility**: Requires Proton versions 9 or below for proper functionality.
*    **Configuration Reset**: Deleting .config/dconf/user.bak will allow you to save new desktop settings (theme, wallpaper, etc.).
     
---

# gow-zorin: Zorin OS для Гейминга - Полное Руководство

Это руководство предоставляет полное описание использования gow-zorin, предустановленной среды Zorin OS, оптимизированной для игр. Оно охватывает описание проекта, сведения о конфигурации, инструкции по развертыванию и советы по устранению неполадок.

## Содержание

*   [Введение](#введение)
*   [Описание](#описание)
*   [Конфигурация](#конфигурация)
*   [Сборка](#сборка)
*   [Устранение неполадок](#устранение-неполадок)

## Введение

gow-zorin стремится предоставить готовую к использованию среду Zorin OS, устраняя сложности ручной настройки для игр.  Эта настройка использует контейнеризацию Docker для переносимости и простоты управления.  Настоящее руководство предполагает базовое понимание концепций Docker.

## Описание

gow-zorin предоставляет полностью функциональную среду Zorin OS с предустановленными инструментами и оптимизированными настройками для бесперебойного игрового опыта. Она обеспечивает привычный интерфейс Windows, используя при этом мощность и гибкость Zorin OS. Ключевые особенности включают:

*   **Предустановленная среда:** Устраняет ручную настройку для игр.
*   **Поддержка игр:** Включает Steam, Heroic Game Launcher и Mango HUD, предустановленные.
*   **Оптимизированная производительность:** Настройки направлены на плавный игровой процесс и отзывчивость.
*   **Настраиваемость:** Предоставляет варианты для пользовательских скриптов и корректировок конфигурации.

## Конфигурация

Этот раздел содержит сведения о конфигурации, необходимой для развертывания среды gow-zorin. Основная конфигурация представлена в формате `config.toml` ниже. **Внимательно изучите каждую настройку, чтобы убедиться в совместимости с вашей системой и желаемой настройкой.**

```toml
[[apps]]
icon_png_path = 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%2Fid%2FOIP.-GsZ83B2UfwcfGYxPs7xKwHaHa%3Fpid%3DApi&f=1&ipt=f5462269e1ce601ba074dd3cfd09c2bb6606850c4f262fe46db1988fe993ed9e'
start_virtual_compositor = true
title = 'Zorin'
    [apps.runner]
    base_create_json = '''{
  "HostConfig": {
    "IpcMode": "host",
    "CapAdd": ["SYS_ADMIN", "SYS_NICE", "SYS_PTRACE", "NET_RAW", "MKNOD", "NET_ADMIN"],
    "SecurityOpt": ["seccomp=unconfined", "apparmor=unconfined"],
    "Ulimits": [{"Name":"nofile", "Hard":524288, "Soft":10240}],
    "Privileged": true,
    "DeviceCgroupRules": ["c 13:* rmw", "c 244:* rmw"]
  }
}
'''
    devices = []
    env = [ 'LC_ALL=ru_RU.UTF-8', 'GOW_REQUIRED_DEVICES=/dev/input/* /dev/dri/* /dev/nvidia*', 'XKB_DEFAULT_LAYOUT=us,ru' ]
    image = 'gailoks/gow-zorin:latest'
    mounts = [ ]
    name = 'WolfZorin'
    ports = []
    type = 'docker'
```

## Сборка 

Чтобы собрать образ используйте следующую команду:

```
docker build -t gailoks/gow-zorin:latest .
```

## Плюсы

*   **Простота использования:** Предварительно настроенная среда экономит значительное время на настройку.
*   **Готовность к играм:** Все необходимые инструменты для игр уже установлены.
*   **Оптимизированная производительность:** Конфигурации направлены на плавную игру и отзывчивость.
*   **Настраиваемость:** Возможность запуска пользовательских скриптов.

## Минусы

*   **Медленный запуск:** Любой запуск будет занимать больше времени чем запуск более легких DE
*   **Интенсивность ресурсов:** Zorin OS, хотя и легкая в своем роде, требует разумных системных ресурсов.

## Устранение неполадок

*   **Совместимость приложений:**  Некоторые приложения могут потребовать дополнительной настройки или устранения неполадок.
*   **Ошибки в журналах:** Проверьте каталог `/logs` на наличие файлов журналов (`dbus.log`, `xdg.log`, `flatpak.log`) для выявления ошибок.
*   **Ошибки пользовательских скриптов:** Проверьте каталог `/logs` на наличие ошибок при выполнении пользовательского скрипта.
*   **Совместимость Proton:** Для корректной работы требуются версии Proton 9 или ниже.
*   **Сброс конфигурации:** Удаление `.config/dconf/user.bak` позволит сохранить новые настройки рабочего стола(тему, обои и тд).

