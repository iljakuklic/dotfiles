# Check github command
if builtin type gh >/dev/null 2>&1; then
    eval "$(gh completion -s bash)"
fi
