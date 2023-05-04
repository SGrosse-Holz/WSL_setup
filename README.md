# My WSL setup
This repo contains my user setup for a fresh WSL instance.

## Major features
 - solarized color scheme for terminal, vim, zathura
 - vimtex + zathura setup in WSL, with forward/backward search
 - vimtex (Windows) + zathura (Ubuntu) setup with forward search

## Minor features
 - vim and zathura automatically adjust to light/dark color scheme of terminal
 - automatically connect to session d-bus, or launch if necessary
 - reminders for other niceties, like ssh keys, git setup, GitHub
   authentication

## Instructions
Download / clone repo; read `user_setup.sh`; execute it after checking what it
does, or do individual steps manually

## Notes
 - you will most likely want to use your own `.vimrc`. In that case you can
   just copy the vimtex and/or solarized config from the one provided here
 - I use the [Neo keyboard
   layout](https://github.com/Rojetto/ReNeo/tree/master); a few mappings in
   `.vimrc` might make little sense with other layouts. Specifically,
   `g:EasyMotion_keys`.
