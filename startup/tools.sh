#!/usr/bin/env bash

set -e

# colors
red="\e[31m"
blue="\e[34m"
yellow="\e[1;33m"
white="\e[0m"

info()
{
	echo -e "$blue info [$(date +'%Y-%m-%d %H:%M:%S')] $white $*"
}

warn()
{
	echo -e "$yellow warn [$(date +'%Y-%m-%d %H:%M:%S')] $white $*"
}

error()
{
	echo -e "$red error [$(date +'%Y-%m-%d %H:%M:%S')] $white $*"
}