#!/bin/sh

guix system build configs/$(hostname).scm --allow-downgrades
guix home build ./home-configuration.scm --allow-downgrades
