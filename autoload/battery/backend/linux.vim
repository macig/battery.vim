" Ref: https://github.com/lambdalisue/battery.vim/issues/7
let s:Job = vital#battery#import('System.Job')
let s:ac_online = get(glob('/sys/class/power_supply/AC*/online', 0, 1), 0, '')
let s:bat_capacity = get(glob('/sys/class/power_supply/BAT*/capacity', 0, 1), 0, '')

function! s:read(path) abort
  let body = readfile(a:path)
  return get(body, 0, '')
endfunction

function! s:linux_update() abort dict
  let self.is_charging = s:read(s:ac_online) ==# '1'
  let self.value = s:read(s:bat_capacity) + 0
endfunction

function! battery#backend#linux#define() abort
  return {
        \ 'value': -1,
        \ 'is_charging': -1,
        \ 'update': funcref('s:linux_update'),
        \}
endfunction

function! battery#backend#linux#is_available() abort
  return !empty(s:ac_online) && !empty(s:bat_capacity)
endfunction
