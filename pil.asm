org 0x7c00 
jmp 0x0000:start

data:
    ans db 0
    ct db 0
    qt db 0
start:
	mov AX, 0011h ;modo video
    mov bh, 0
	mov bl, 5
	int 10h

    push 1

    mov ah, 0           ;vai ler e printar o numero de casos
	int 16h
    mov ah, 0xe
	int 10h

    sub al, '0'         ;subtraio o valor do caractere 0 (?)
    add al, 1
    mov [ct], al        ;vai salvar o numero de casos em ct (?)
    
    xor ax, ax
    mov [qt], al

    mov ah, 0           ;ler e printar o /n
    int 16h
    mov ah, 0xe
	int 10h

    mov dh, 0           ;zero o dh
lerCt:                      ;fazer o loop dos casos testes e pular a linha
    .loop:
        mov ah, 02h         ;colocando o cursor na próxima linha
        mov bh, 0
        add dh, 1
        mov dl, 0
        int 10h

        mov ah, 1       ;subtraio 1 dos casos testes
        sub [ct], ah

        xor ah, ah
        cmp [ct], ah    ;verifico se ja acabaram os casos testes
        je .endloop     ;caso tenha acabado termino o programa (fase teste)

        jmp lerEnt      ;vou ler a string

        add [qt], ah    ;incrementa a quantidade de entradas lidas

        jmp .loop
    .endloop:
        jmp fim
lerEnt:
    .loop:
        mov ah, 0       ;leio mais um caracter
        int 16h
        cmp al, 13      ;se foi /n reinicio o loop
        je .endloop

        mov ah, 0xe     ;se nao foi /n eu imprimo o caracter na tela
        int 10h 

        cmp al, '('
        je empilhaP
        cmp al, ')'
        je desempilhaP

        jmp .loop       ;e continuo o loop
    .endloop:
        mov ah, 0xe
        int 10h
        jmp lerCt
empilhaP:
    push ax
    jmp lerEnt
desempilhaP:
    pop ax
    
    cmp al, 1
    je salvaNao

    cmp al, '('
    jne salvaNao

    jmp lerEnt
salvaNao:
    mov al, 'N'
    mov si, ans
    add si, [qt]
    stosb
    jmp desempilhaP
comparaChar:
    cmp al, '('
    je .empilha
    cmp al, '['
    je .empilha
    cmp al, '{'
    je .empilha

    cmp al, ')'
    je .confere1
    cmp al, ']'
    je .confere2
    cmp al, '}'
    je .confere3

    .ignora:
        ret
    .confere1:
        pop ax
        cmp al, '('
        je lerEnt
        jmp .errado
    .confere2:
        pop ax
        cmp al, '['
        jne .errado
        ret
    .confere3:
        pop ax
        cmp al, '{'
        jne .errado
        ret
    .empilha:
        push ax
        ret
    .errado:
        jmp $

fim:
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55