#!/bin/sh


distro=stretch

for i in $(cat packages); do


    curl  "https://packages.debian.org/$distro/i386/$i/download" |   grep  ftp.de.debian.org | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^"]+'
  #  curl  "https://packages.debian.org/$distro//i386/$i/download" |   grep http://security.ubuntu.com | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^"]+'

  done