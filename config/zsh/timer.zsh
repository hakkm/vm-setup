zmodload zsh/datetime

__timer_current_time() {
  zmodload zsh/datetime
  echo $EPOCHREALTIME
}

__timer_format_duration() {
    local total=${1:-0}
    local precision=${TIMER_PRECISION:-3}
    local hours mins secs

    hours=$(awk -v t="$total" 'BEGIN{printf("%d", t/3600)}')
    if [ "$hours" -gt 0 ]; then
        mins=$(awk -v t="$total" -v h="$hours" 'BEGIN{rem=t-h*3600; printf("%02d", int(rem/60))}')
        secs=$(awk -v t="$total" -v h="$hours" -v p="$precision" 'BEGIN{rem=t-h*3600; s=rem - int(rem/60)*60; printf("%02.*f", p, s)}')
        printf "%s:%s:%ss\n" "$hours" "$mins" "$secs"
        return
    fi

    mins=$(awk -v t="$total" 'BEGIN{printf("%d", t/60)}')
    if [ "$mins" -gt 0 ]; then
        secs=$(awk -v t="$total" -v p="$precision" 'BEGIN{m=int(t/60); s=t-m*60; printf("%02.*f", p, s)}')
        printf "%dm:%ss\n" "$mins" "$secs"
    else
        secs=$(awk -v t="$total" -v p="$precision" 'BEGIN{printf("%.*f", p, t)}')
        printf "%ss\n" "$secs"
    fi
}
__timer_save_time_preexec() {
  __timer_cmd_start_time=$(__timer_current_time)
}

__timer_display_timer_precmd() {
  if [ -n "${__timer_cmd_start_time:-}" ]; then
    local cmd_end_time=$(__timer_current_time)
    local tdiff=$((cmd_end_time - __timer_cmd_start_time))
    unset __timer_cmd_start_time
    if [[ -z "${TIMER_THRESHOLD:-}" || ${tdiff} -ge "${TIMER_THRESHOLD:-0}" ]]; then
      local last_cmd="${history[$((HISTCMD - 1))]%% *}"
      if [[ "$last_cmd" != clear ]]; then
        local tdiffstr=$(__timer_format_duration ${tdiff})
        local cols=$((COLUMNS - ${#tdiffstr} - 1))
        echo -e "\033[1A\033[${cols}C ${tdiffstr}"
      fi 
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec __timer_save_time_preexec
add-zsh-hook precmd __timer_display_timer_precmd
