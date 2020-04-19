#!/bin/sh


distro=bionic

for i in $(cat packages); do


    curl  "https://packages.ubuntu.com/$distro/i386/$i/download"  |   grep  de.archive.ubuntu.com | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^"]+'
    curl  "https://packages.ubuntu.com/$distro//i386/$i/download" |   grep http://security.ubuntu.com | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^"]+'

  done