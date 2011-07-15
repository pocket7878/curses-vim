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

"Buffer line buffer.
let b:buff = []
"curses status
let b:bufCursed = -1

function! curses#initScr()
        "if Buffer does'nt cursed
        if b:bufCursed != -1
                "Save buffer data
                for i in range(1, s:getbufHeight()):
                        call add(b:buff, getline(i))
                endfor
                "Clean buffer
                silent % delete _
                "Fill window by space
                for i in range(1,winheight('%')):
                        call setline(i, repeat(' ', winwidth(i)))
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
                for i in range(0, len(b:buff)):
                        call setline(i+1, b:buff[i])
                endfor
        endif
endfunction

function! curses#erase()
        "Fill window by space
        for i in range(1,winheight('%')):
                call setline(i, repeat(' ', winwidth(i)))
        endfor
endfunction

function! curses#move(y, x)
        call setpos('.', [0, a:y, a:x, 0])
endfunction

function! curses#addch(char)
        "Get line as arry
        let l:curLine = split(getline('.'),'\zs')
        "Get cursor pos
        let l:curPos = getpos('.')
        "Replace charactor
        let l:curLine[l:curPos[2]] = a:char
        "Replace line
        call setline('.',join(l:curLine, ''))
        "Forword cursor
        exec "normal l"
endfunction

function! cursor#insch(char)
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
