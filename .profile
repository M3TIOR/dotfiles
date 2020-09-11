# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if test -n "$BASH_VERSION"; then
	# include .bashrc if it exists
	if test -f "$HOME/.bashrc"; then
		. "$HOME/.bashrc";
  fi;
fi;

# set PATH so it includes user's private bin if it exists
if test -d "$HOME/bin"; then
	export PATH="$HOME/bin:$PATH";
fi;

# set PATH so it includes user's private bin if it exists
if test -d "$HOME/.local/bin"; then
	export PATH="$HOME/.local/bin:$PATH";
fi;

if test -d "$HOME/.profile.d"; then
	LINK_NAME='';
	FILE_NAME='';
	for file in $HOME/.profile.d/*; do
		# Just run all for now, this can be modified for machine specific config
		# later hopefully by using Yadm's builtin configuration method.
		FILE_NAME="${file##*\/}";
		if test -L "$file"; then
			LINK_NAME="$FILE_NAME";
			. "$file";
		else
			# If the file name is the same as our last link minus the yadm
			# template config suffix, then we don't execute it.
			# This should work assuming strings are read in alpha-numeric order.
			if test "$LINK_NAME" != "${FILE_NAME%%\#\#*}"; then
				. "$file";
			fi;
		fi;
	done;
	unset LINK_NAME;
	unset FILE_NAME;
fi;

# NOTE : Below are programatically generated insertions. DO NOT EDIT
