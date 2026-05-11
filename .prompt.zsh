# Single-line prompt with at-a-glance host context. Sourced from .zshrc
# after Oh My Zsh loads, so it overrides whatever theme the OMZ line picked.
#
# Layout:
#   <host> ~/path ⎇ branch *  λ                                    ✗1 4.2s
#
# - Host name is color-coded by hashing $DEPLOYMENT_NAME (or $(hostname -s)),
#   so each devbox/laptop reads as a consistent color across sessions.
# - Right side stays empty unless the last command failed or took >3s.

autoload -U colors && colors
zmodload zsh/datetime
setopt prompt_subst

# Deterministic per-host color: hash the host name → one of N ANSI 256 codes.
_devbox_color() {
  local name="${DEPLOYMENT_NAME:-$(hostname -s)}"
  local palette=(34 33 35 36 32 31 38 94 95 96)
  local sum=0 i
  for (( i=1; i<=${#name}; i++ )); do
    sum=$(( sum + #name[i] ))
  done
  echo ${palette[$(( (sum % ${#palette[@]}) + 1 ))]}
}
DEVBOX_COLOR=$(_devbox_color)

# Git branch + dirty marker. Cheap: one symbolic-ref + one status --porcelain.
_git_prompt() {
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) || return
  local dirty=""
  [[ -n $(command git status --porcelain 2>/dev/null) ]] && dirty="*"
  print -n " %F{105}⎇ ${branch}%f%F{yellow}${dirty}%f"
}

# Last command duration, shown only when > 3s.
_cmd_timer_pre()  { _cmd_start=$EPOCHREALTIME }
_cmd_timer_post() {
  _cmd_duration=""
  if [[ -n $_cmd_start ]]; then
    local elapsed=$(( EPOCHREALTIME - _cmd_start ))
    (( elapsed > 3 )) && _cmd_duration=$(printf '%.1fs' $elapsed)
    unset _cmd_start
  fi
}
preexec_functions+=( _cmd_timer_pre )
precmd_functions+=( _cmd_timer_post )

PROMPT='%F{$DEVBOX_COLOR}%B${DEPLOYMENT_NAME:-%m}%b%f %F{245}%~%f$(_git_prompt) λ '
RPROMPT='%(?..%F{red}✗%? %f)%F{yellow}${_cmd_duration}%f'
