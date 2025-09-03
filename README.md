# gow-zorin - Zorin OS for Gaming

This project aims to create a pre-configured Zorin OS environment optimized for gaming. It has great potential and extensibility.

## Contents

*   [Introduction](#introduction)
*   [Features](#features)
*   [Installation](#installation)
*   [Configuration](#configuration)
*   [Scripts](#scripts)
*   [Pros](#pros)
*   [Cons](#cons)
*   [Troubleshooting](#troubleshooting)
*   [Known Issues](#known issues)

## Introduction

gow-zorin provides a ready-to-use Zorin OS environment. This is a great option for those who want a customized gaming environment without going through the complex setup process. It's designed to emulate a desktop environment and provide users with a familiar Windows-like interface.

## Features

*   **Zorin OS Desktop:** Provides a fully functional Zorin OS environment.
*   **Gaming Support:** Includes Steam, Heroic Game Launcher, and Mango HUD pre-installed.
*   **Flatpak Integration:**  Provides a secure application model and seamless integration with Gnome Software.
*   **Optimized Configuration:** Keyboard functionality, smooth performance, and pre-configured settings.

## Installation

The installation process depends on your chosen containerization method. Refer to the project’s documentation (link to documentation here) for specific instructions. Generally, it involves deploying the image or script into your container environment.

## Configuration

After deployment, most settings are saved automatically. However, if you need to change them:

*   **Important:** To modify settings, delete the file `.config/dconf/user.bak` in the user’s home directory. This will clear the saved configurations, allowing you to start fresh.

## Scripts

You can run your own scripts by placing them in the `/custom-script` file. Make sure the script has execute permissions (`chmod +x /custom-script`). Any errors during script execution will be logged.

## Pros

*   **Ease of Use:** The pre-configured environment saves significant setup time.
*   **Gaming Ready:** All necessary gaming tools are already installed.
*   **Optimized Performance:** Configurations are aimed at smooth gameplay and responsiveness.
*   **Customizability:** Ability to run custom scripts.

## Cons

*   **Slow Startup:** Any startup will take longer than a startup of lighter DEs.
*   **Resource Intensity:** Zorin OS, although lightweight in its own right, requires reasonable system resources.
*   **Configuration Reset:** Deleting `.config/dconf/user.bak` will delete all saved configurations.

## Troubleshooting

*   **Application Compatibility:** Some applications may require additional configuration or troubleshooting.
*   **Errors in Logs:** Check the `/logs` directory for log files (`dbus.log`, `xdg.log`, `flatpak.log`) to identify errors.
*   **Errors in Custom Scripts:** Check the `/logs` directory for errors when running your custom script.
*   **Proton Compatibility:** Versions 9 or below of Proton are required for correct operation.

---

## Перевод на Русский (Russian Translation)

# gow-zorin - Zorin OS для игр

Этот проект направлен на создание предварительно настроенной среды Zorin OS, оптимизированной для игр. Имеет большой потенциал и расширяемость. 

## Содержание

*   [Введение](#введение)
*   [Особенности](#особенности)
*   [Установка](#установка)
*   [Конфигурация](#конфигурация)
*   [Скрипты](#скрипты)
*   [Плюсы](#плюсы)
*   [Минусы](#минусы)
*   [Устранение неполадок](#устранение-неполадок)
*   [Известные проблемы](#известные-проблемы)

## Введение

gow-zorin предоставляет готовую среду Zorin OS. Это отличный вариант для тех, кто хочет настроенную среду для игр не проходя через сложный процесс настройки.  Предназначена для имитации рабочего стола и предоставления знакомого пользователям интерфейса windows.

## Особенности

*   **Рабочий стол Zorin OS:** Предоставляет полностью функциональную среду Zorin OS.
*   **Поддержка игр:** Включает Steam, Heroic Game Launcher и Mango HUD, предустановленные.
*   **Интеграция Flatpak:**  Обеспечивается безопасной моделью приложения Flatpak и бесшовной интеграцией Gnome Software.
*   **Оптимизированная конфигурация:**  Функциональность клавиатуры, плавная производительность и предварительно настроенные параметры.

## Установка

Процесс установки зависит от выбранного вами метода контейнеризации. Обратитесь к документации проекта (ссылка на документацию здесь) для получения конкретных инструкций. В целом, это включает в себя развертывание образа или скрипта в вашей контейнерной среде.

## Конфигурация

После развертывания большинство настроек сохраняются автоматически. Однако, если вам необходимо их изменить:

*   **Важно:** Чтобы изменить настройки, удалите файл `.config/dconf/user.bak` в домашней директории пользователя. Это очистит сохраненные конфигурации, что позволит вам начать с нуля.

## Скрипты

Вы можете выполнять собственные скрипты, помещая их в файл `/custom-script`. Убедитесь, что у скрипта есть права на исполнение (`chmod +x /custom-script`). Любые ошибки во время выполнения скрипта будут зафиксированы.

## Плюсы

*   **Простота использования:** Предварительно настроенная среда экономит значительное время на настройку.
*   **Готовность к играм:** Все необходимые инструменты для игр уже установлены.
*   **Оптимизированная производительность:** Конфигурации направлены на плавную игру и отзывчивость.
*   **Настраиваемость:** Возможность запуска пользовательских скриптов.

## Минусы

*   **Медленный запуск:** Любой запуск будет занимать больше времени чем запуск более легких DE
*   **Интенсивность ресурсов:** Zorin OS, хотя и легкая в своем роде, требует разумных системных ресурсов.
*   **Сброс конфигурации:** Удаление `.config/dconf/user.bak` удалит все сохраненные конфигурации.

## Устранение неполадок

*   **Совместимость приложений:**  Некоторые приложения могут потребовать дополнительной настройки или устранения неполадок.
*   **Ошибки в журналах:** Проверьте каталог `/logs` на наличие файлов журналов (`dbus.log`, `xdg.log`, `flatpak.log`) для выявления ошибок.
*   **Ошибки пользовательских скриптов:** Проверьте каталог `/logs` на наличие ошибок при выполнении пользовательского скрипта.
*   **Совместимость Proton:** Для корректной работы требуются версии Proton 9 или ниже.
