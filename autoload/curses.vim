let s:V = vital#of('curses_vim')

function! s:getbufHeight()"{{{
        return line('$')
endfunction"}}}

function! s:max(a, b)"{{{
        if a:a >= a:b
                return a:a
        else
                return a:b
        endif
endfunction"}}}

function! s:min(a, b)"{{{
        if a:a <= a:b
                return a:a
        else
                return a:b
        endif
endfunction"}}}

function! curses#initScr()"{{{
        "if Buffer does'nt cursed
        if !exists('b:bufCursed')
                "Save line number option
                let b:numOpt = &number 
                set nonumber
                let b:wrapOpt = &wrap
                set nowrap
                "Buffer line buffer.
                let b:buff = [] 
                "Save buffer data
                for i in range(1, s:getbufHeight())
                        call add(b:buff, getline(i))
                endfor
                "Clean buffer
                silent % delete _
                "Fill window by space
                for i in range(1,winheight('%'))
                        call setline(i, repeat(' ', winwidth(0)-1))
                endfor
                "" Initialize buffer local variables
                "set cursed flag
                let b:bufCursed = 1       
                "reset timeout if it already setup
                if exists('b:timeout')
                        let b:timeout = -1
                endif
                "refresh screen
                redraw
        endif
endfunction"}}}

function! curses#endWin()"{{{
        if b:bufCursed == 1
                "clean buffer
                silent % delete _
                "Insert buffer data
                for i in range(1, len(b:buff))
                        call setline(i, b:buff[i - 1])
                endfor
                "Set number option
                if b:numOpt == 1
                        set number
                endif
                if b:wrapOpt == 1
                        set wrap
                endif
                unlet b:bufCursed
        endif
endfunction"}}}

function! curses#erase()"{{{
        "Fill window by space
        for i in range(1,winheight('%'))
                call setline(i, repeat(' ', winwidth(0)))
        endfor
        redraw
endfunction"}}}

function! curses#move(y, x)"{{{
        call setpos('.', [bufnr('%'), a:y, a:x, 0])
endfunction"}}}

function! curses#addch(char)"{{{
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        let l:curLine[l:curPos[2] - 1] = a:char
        "Replace line
        call setline('.',join(l:curLine, ''))
        "Forword cursor
        exec "normal l"
endfunction"}}}

function! curses#mvaddch(y, x, char)"{{{
        call curses#move(a:y, a:x)
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        let l:curLine[l:curPos[2] - 1] = a:char
        "Replace line
        call setline('.',join(l:curLine, ''))
        "Forword cursor
        exec "normal l"
endfunction"}}}

function! curses#echochar(char)"{{{
        call curses#addch(a:char)
        redraw
endfunction"}}}

function! curses#mvechochar(y, x, char)"{{{
        call curses#mvaddch(a:y, a:x, a:char)
        redraw
endfunction"}}}

function! curses#insch(char)"{{{
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        call insert(l:curLine, a:char, l:curPos[2])
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction"}}}

function! curses#mvinsch(y, x, char)"{{{
        call curses#move(a:y, a:x)
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        call insert(l:curLine, a:char, l:curPos[2])
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction"}}}

function! curses#delch()"{{{
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        let l:curLine[l:curPos[2]] = ' '
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction"}}}

function! curses#fill(char)"{{{
        "Fill window by a:char
        for i in range(1,winheight('%'))
                call setline(i, repeat(a:char, winwidth(0)))
        endfor
endfunction"}}}

function! curses#clrline(linum)"{{{
        call setline(a:linum, repeat(' ', winwidth(0)))
        redraw
endfunction"}}}

function! curses#clrtoeol()"{{{
        let l:curPos = getpos('.')
        for i in range(l:curPos[1],winheight('%'))
                call setline(i, repeat(' ', winwidth(0)))
        endfor
        redraw
endfunction"}}}

function! curses#clrtobot()"{{{
        let l:curPos = getpos('.')
        let l:curLine = split(getline('.'),'\zs')
        for i in range(l:curPos[2],len(l:curLine))
                l:curLine[i-1] = ' '
        endfor
        for i in range(l:curPos[1] + 1,winheight('%'))
                call setline(i, repeat(' ', winwidth(0)))
        endfor
        redraw
endfunction"}}}

function! curses#getch()"{{{
        if !exists('b:timeout') || b:timeout < 0 
                return s:V.getchar()
        else
                let l:k = b:timeout
                while  l:k > 0 && s:V.getchar(1) == 0
                        sleep 10m
                        let l:k = l:k - 10
                endwh
                return s:V.getchar(1)
        endif
endfunction"}}}

function! curses#timeout(milli)"{{{
        let b:timeout = a:milli
endfunction"}}}

function! curses#printw(str)"{{{
        "Given str as arry
        let l:strArry = split(a:str,'\zs')
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "difference display str size and str len
        let l:diff = s:V.wcswidth(a:str)-s:V.strchars(a:str)
        "Replace charactor and resize line buf
        for i in range(l:curPos[2], l:curPos[2] + s:min(len(l:strArry), len(l:curLine)) - 1)
                let l:curLine[i-1] = l:strArry[i-l:curPos[2]]
        endfor
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction"}}}

function! curses#mvprintw(y, x, str)"{{{
        "Move cursor
        call curses#move(a:y, a:x)
        "Given str as arry
        let l:strArry = split(a:str,'\zs')
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        for i in range(l:curPos[2], l:curPos[2] + s:min(len(l:strArry), len(l:curLine)) - 1)
                let l:curLine[i-1] = l:strArry[i-l:curPos[2]]
        endfor
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction"}}}
