#!/usr/bin/env zsh

function ascii () {
  setopt local_options warn_create_global no_octal_zeroes

  local -ra esc_chrs=(
    'SOH' 'STX' 'ETX' 'EOT' 'ENQ' 'ACK' '\a'  '\b'  '\t'  '\n'  '\v'  '\f' '\r'
    'SO'  'SI'  'DLE' 'DC1' 'DC2' 'DC3' 'DC4' 'NAK' 'SYN' 'ETB' 'CAN' 'EM' 'SUB'
    '\e'  'FS'  'GS'  'RS'  'US'  'SP' [0x7F]='DEL' '\0'
  )

  local line chr
  local -i 10 i
  local -a lines

  for i in {0..127}; {
    line="${(l:2:)$(( [##16]i ))} ${(l:3:)i} ${(l:3:)$(( [##8]i ))} "

    if   (( i <= 0x1F )) { eval "line+=$'^\x$(( [##16]( ##@ + i ) ))'"; } \
    elif (( i == 0x7F )) {       line+='^?'                           ; } \
    else                 {       line+='  '                           ; }

    if ! [[ ${chr::=$esc_chrs[ i ? i : -1 ]} ]] eval "chr=$'\x$(( [##16]i ))'"

    lines+=( "$line $chr   " )
  }

  print -rc -- "${(@)lines}"
}

if [[ "$ZSH_EVAL_CONTEXT" == 'toplevel' ]] ascii "$@"
