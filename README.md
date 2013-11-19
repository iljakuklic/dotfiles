# dotfiles

This repository contains various bits and pieces of useful configuration.
It is divided into several modules, each module is represented by a subdirectory.
It is meant to be managed by [GNU Stow](http://www.gnu.org/software/stow/).

## Motivation

[GitHub does dotfiles](http://dotfiles.github.io/)

*Why git?* (TODO)

*Why GNU stow?* (TODO)

## Setup

Clone this repo into your home directory:

	cd ~
	git clone git@github.com:iljakuklic/dotfiles.git

Install the module for your shell. Many other modules depend on it.
Only bash is supported ATM (contributions towards supporting other shells welcome).
It is a good idea to backup the original scripts first
(`stow` will refuse to install the module if the are present).

	for F in .bash_logout .bash_profile .bashrc; do mv ~/$F ~/$F.bak; done
	cd ~/dotfiles
	stow bash

(TODO git submodules)

## Install modules

In the `dotfiles` directory, install some modules using `stow`:

	cd ~/dotfiles
	stow <MODULES>

(TODO discuss module documentation and dependencies)

## Update modules

(TODO)

## Remove modules

(TODO)

## Questions & Answers

(TODO)

