let s:V = vital#of('curses_vim')

function! s:getmaxwcswidth(list)"{{{
        let l:maxLen = 0
        for item in a:list
                let l:maxLen = l:maxLen >= s:V.wcswidth(item) ? l:maxLen : s:V.wcswidth(item)
        endfor
        return l:maxLen
endfunction"}}}

function! curses#display#cprintw(str)"{{{
        "Calc start pos of printw
        let l:strLen = s:V.wcswidth(a:str)
        let l:cursorPos = curses#info#curPos()
        "Print string
        call curses#mvprintw(l:cursorPos[0], curses#info#cols()/2 - (l:strLen/2), a:str)
endfunction"}}}

function! curses#display#mvcprintw(y, str)"{{{
        let l:curX = curses#info#curPosX()
        call curses#move(a:y, l:curX)
        call curses#display#cprintw(a:str)
endfunction"}}}

function! curses#display#printList(dot, list)"{{{
        "Cursor x and y
        let l:curX = curses#info#curPosX()
        let l:curY = curses#info#curPosY()
        for idx in range(0, len(a:list)-1)
                call curses#mvprintw(l:curY + idx, 
        \                               l:curX,
        \                               a:dot.a:list[idx])
        endfor
endfunction"}}}

function! curses#display#nprintList(list)"{{{
        "Cursor x and y
        let l:curX = curses#info#curPosX()
        let l:curY = curses#info#curPosY()
        for idx in range(0, len(a:list)-1)
                call curses#mvprintw(l:curY + idx, 
        \                               l:curX,
        \                               (idx+1).'. '.a:list[idx])
        endfor
endfunction"}}}

function! curses#display#mvprintList(y, x, dot, list)"{{{
        "Move cursor
        call curses#move(a:y, a:x)
        "Display List
        call curses#display#printList(a:dot, a:list)
endfunction"}}}

function! curses#display#mvnprintList(y, x, list)"{{{
        "Move cursor
        call curses#move(a:y, a:x)
        "Display List
        call curses#display#nprintList(a:list)
endfunction"}}}

function! curses#display#cprintList(dot, list)"{{{
        "Calc max len
        let l:maxLen = s:getmaxwcswidth(a:list) 
        "Current cursor y pos
        let l:posY = curses#info#curPosY()
        "Print string
        call curses#display#mvprintList(l:posY, curses#info#cols()/2 - (l:maxLen/2),a:dot, a:list)
endfunction"}}}

function! curses#display#mvcprintList(y,dot, list)"{{{
        "Calc max len
        let l:maxLen = s:getmaxwcswidth(a:list) 
        "Print string
        call curses#display#mvprintList(a:y, curses#info#cols()/2 - (l:maxLen/2),a:dot, a:list)
endfunction"}}}

function! curses#display#cnprintList(list)"{{{
        "Calc max len
        let l:maxLen = s:getmaxwcswidth(a:list) 
        "Current cursporPos
        let l:posY = curses#info#curPosY()
        "Print string
        call curses#display#mvnprintList(l:posY, curses#info#cols()/2 - (l:maxLen/2), a:list)
endfunction"}}}

function! curses#display#mvcnprintList(y,list)"{{{
        "Calc max len
        let l:maxLen = s:getmaxwcswidth(a:list) 
        "Print string
        call curses#display#mvnprintList(a:y, curses#info#cols()/2 - (l:maxLen/2), a:list)
endfunction"}}}

function! curses#display#printhl()"{{{
        "Print holizontal line
        call curses#printw(repeat('-',curses#info#cols()))
endfunction"}}}

function! curses#display#mvprinthl(y)"{{{
        call curses#mvprintw(a:y, 1, repeat('-',curses#info#cols()))
endfunction"}}}
