#!/bin/bash
echo "cleaning arty"
if [ -d "arty/arty.cache" ]; then rm -Rf "arty/arty.cache"; fi
if [ -d "arty/arty.gen" ]; then rm -Rf "arty/arty.gen"; fi
if [ -d "arty/arty.ip_user_files" ]; then rm -Rf "arty/arty.ip_user_files"; fi
if [ -d "arty/arty.runs" ]; then rm -Rf "arty/arty.runs"; fi
if [ -d "arty/arty.sim" ]; then rm -Rf "arty/arty.sim"; fi

