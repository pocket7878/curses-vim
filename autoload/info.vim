"Get infomation about cursor pos, screen size...etc.

"cursor position x and y
function! curses#curPosX()
        let l:curPos = getpos('.')
        return l:curPos[2]
endfunction

function! curses#curPosY()
        let l:curPos = getpos('.')
        return l:curPos[1]
endfunction

function! curses#curPos()
        let l:curPos = getpos('.')
        return [l:curPos[1], l:curPos[2]]
endfunction

"screen size info
function! curses#cols()
        return winwidth(0)
endfunction

function! curses#rows()
        return winheight(0)
endfunction

function! curses#size()
        return [winheight(0), winwidth(0)]
endfunction
