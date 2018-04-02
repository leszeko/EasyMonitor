#!\bin\bash
PS1="\n\[\e[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\e[01;31m\]\h'; else echo '\[\e[01;34m\]\u@\h'; fi)\[\e[1;37m\])\$([[ \$? != 0 ]] && echo \"\342\224\200(\[\e[0;31m\]\342\234\227\[\e[1;37m\])\")\342\224\200(\[\e[1;34m\]\@ \d\[\e[1;37m\])\[\e[1;37m\]\n\342\224\224\342\224\200(\[\e[1;32m\]\w\[\e[1;37m\])\342\224\200(\[\e[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 insgesamt | sed 's/insgesamt //')b\[\e[1;37m\])\n\[\e[01;34m\]$ \[\e[0m\]"
export PS1

if [ "$USER" = "plasmarob" ]; then
    p="\[\033[01;38;5;52m\]p"
    l="\[\033[01;38;5;124m\]l"
    a="\[\033[01;38;5;196m\]a"
    s="\[\033[01;38;5;202m\]s"
    m="\[\033[01;38;5;208m\]m"
    a2="\[\033[01;38;5;214m\]a"
    r="\[\033[01;38;5;220m\]r"
    o="\[\033[01;38;5;226m\]o"
    b="\[\033[01;38;5;228m\]b"
    local __user_and_host="$p$l$a$s$m$a2$r$o$b"
else
    local __user_and_host="\[\033[01;36m\]\u"
fi   

...

export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
#Note that the 01 prefix in a string like \[\033[01;38;5;214m\]a sets it to be bold.

exitstatus()
{
    if [[ $? == 0 ]]; then
        echo ':)'
    else
        echo 'D:'
    fi
}
export PS1='$(exitstatus) > '