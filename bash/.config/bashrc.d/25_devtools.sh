# Check github command, set up completions if present
#iscmd gh --eval completion -s bash
if iscmd gh; then
  __COMPLETION_DONE_GH=false
  function __lazy_start_gh {
    if ! $__COMPLETION_DONE_GH; then
      source <(gh completion -s bash)
      __COMPLETION_DONE_GH=true
      __start_gh "$@"
    fi
  }
  complete -o default -F __lazy_start_gh gh
fi
