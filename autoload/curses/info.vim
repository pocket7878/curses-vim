"Get infomation about cursor pos, screen size...etc.

"cursor position x and y
function! curses#info#curPosX()
        let l:curPos = getpos('.')
        return l:curPos[2]
endfunction

function! curses#info#curPosY()
        let l:curPos = getpos('.')
        return l:curPos[1]
endfunction

function! curses#info#curPos()
        let l:curPos = getpos('.')
        return [l:curPos[1], l:curPos[2]]
endfunction

"screen size info
function! curses#info#cols()
        return winwidth(0)
endfunction

function! curses#info#rows()
        return winheight(0)
endfunction

function! curses#info#size()
        return [winheight(0), winwidth(0)]
endfunction
