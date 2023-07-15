# largefile: top 10 largest file
large() {
    du -a $@ | sort -n -r | head -n 10
}

# ff:  to find a file under the current directory
ff() { /usr/bin/find . -name "$@"; }
# ffs: to find a file whose name starts with a given string
ffs() { /usr/bin/find . -name "$@"'*'; }
# ffe: to find a file whose name ends with a given string
ffe() { /usr/bin/find . -name '*'"$@"; }
# zipf: to create a ZIP archive of a file or folder
zipf() { zip -r "$1".zip "$1"; }
# numberLines: echo the lines of a file preceded by line number
numberLines() { perl -pe 's/^/$. /' "$@"; }
# allStrings: show all strings (ASCII & Unicode) in a file
allStrings() { cat "$1" | tr -d "\0" | strings; }

extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xvjf "$1" ;;
        *.tar.gz) tar xvzf "$1" ;;
        *.tar.xz) tar xvJf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xvf "$1" ;;
        *.tbz2) tar xvjf "$1" ;;
        *.tgz) tar xvzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *.xz) unxz "$1" ;;
        *.exe) cabextract "$1" ;;
        *) echo "'$1': unrecognized file compression" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
