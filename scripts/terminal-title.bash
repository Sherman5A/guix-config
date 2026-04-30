
case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|interix|term|foot)
		PS1='\e]0;\u@\h: \w${GUIX_ENVIRONMENT:+ [env]}\e\\ '
		;;
	screen*)
		PS1='\u@\h \w${GUIX_ENVIRONMENT:+ [env]}\$ '
		;;
	*)
		unset PS1
		;;
esac

PS1+='\u@\h \w${GUIX_ENVIRONMENT:+ [env]}\$ '

