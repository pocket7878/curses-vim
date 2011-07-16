let s:V = vital#of('curses_vim')

function! curses#cprintw(str)
        "Calc start pos of printw
        let l:strLen = s:V.wcswidth(a:str)
        let l:cursorPos = curses#getPos()
        "Print string
        call curses#mvprintw(l:cursorPos[1], l:cursorPos[2]-l:strLen, a:str)
endfunction

function! curses#mvcprintw(y, str)
        let l:curX = curses#getPosX()
        call curses#move(a:y, l:curX)
        call curses#cprintw(a:str)
endfunction

"Display item list
function! curses#printList(dot, list)
        "Cursor x and y
        let l:curX = curses#getPosX()
        let l:curY = curses#getPosY()
        for idx in (0, len(a:list) -1)
                call curses#mvprintw(l:curY + idx, 
                                        l:curX,
                                        a:dot.a:list[idx])
        endfor
endfunction

function! curses#mvprintList(y, x, dot, list)
        "Move cursor
        call curses#move(a:y, a:x)
        "Display List
        call curses#printList(a:dot, a:list)
endfunction
