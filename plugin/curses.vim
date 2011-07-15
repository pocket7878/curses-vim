function! s:getbufHeight()
        let l:height = 0
        python<<EOM
import vim
def getBufHeight():
        buf = vim.current.buffer
        return len(buf)
vim.command('let l:height=%s' % getBufHeight())
EOM
        return l:height
endfunction

function! curses#initScr()
        "if Buffer does'nt cursed
        if !exists('b:bufCursed')
                "Save line number option
                let b:numOpt = &number 
                set nonumber
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
                "set cursed flag
                let b:bufCursed = 1       
        endif
endfunction

function! curses#endWin()
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
                unlet b:bufCursed
        endif
endfunction

function! curses#erase()
        "Fill window by space
        for i in range(1,winheight('%'))
                call setline(i, repeat(' ', winwidth(0)))
        endfor
endfunction

function! curses#move(y, x)
        call setpos('.', [bufnr('%'), a:y, a:x, 0])
endfunction

function! curses#addch(char)
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
endfunction

function! curses#mvaddch(y, x, char)
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
endfunction

function! curses#echochar(char)
        call curses#addch(a:char)
        redraw!
endfunction

function! curses#insch(char)
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        call insert(l:curLine, a:char, l:curPos[2])
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction

function! curses#mvinsch(y, x, char)
        call curses#move(a:y, a:x)
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        call insert(l:curLine, a:char, l:curPos[2])
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction


function! curses#delch()
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        let l:curLine[l:curPos[2]] = ' '
        "Replace line
        call setline('.',join(l:curLine, ''))
endfunction

function! curses#fill(char)
        "Fill window by a:char
        for i in range(1,winheight('%'))
                call setline(i, repeat(a:char, winwidth(0)))
        endfor
endfunction

function! curses#clrtoeol()
        let l:curPos = getpos('.')
        for i in range(l:curPos[1],winheight('%'))
                call setline(i, repeat(' ', winwidth(0)))
        endfor
endfunction

function! curses#clrtobot()
        let l:curPos = getpos('.')
        let l:curLine = split(getline('.'),'\zs')
        for i in range(l:curPos[2],len(l:curLine))
                l:curLine[i-1] = ' '
        endfor
        for i in range(l:curPos[1] + 1,winheight('%'))
                call setline(i, repeat(' ', winwidth(0)))
        endfor
endfunction
