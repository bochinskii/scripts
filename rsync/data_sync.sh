#!/usr/bin/bash

ps ax | grep -v grep | grep -q "proftpd: (accepting connections)" && rsync -az --delete /home/ slave:/home/
