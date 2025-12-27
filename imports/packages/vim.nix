
{ config, pkgs, ... }:
let
in
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ((vim-full.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = ''
        " your custom vimrc
        set mouse=a
        set nocompatible
        colo torte
        syntax on
        set tabstop     =2
        set softtabstop =2
        set shiftwidth  =2
        set expandtab
        set autoindent
        set smartindent
        " ...
      '';
    }
    ) 
  ];
}