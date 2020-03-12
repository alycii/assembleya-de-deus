org 0x7c00
jmp 0x0000:start 
data:
    enta db 20, 0, 0
    lixo db "k", 10, 10, 0
    nTem db "NAO EXISTEz", 13, 10, 0
    verd db 'VERDEz', 13, 10, 0
    amar db "AMARELOz", 13, 10, 0
    azul db "AZULz", 13, 10, 0
    verm db "VERMELHOz", 13, 10, 0
    
    endl db ' ', 13, 10, 0 ;printar um \n

lerChar:
    mov ah, 0x00
    int 16h
    ret
printChar:   
    mov ah, 0xe
    int 10h
    ret
lerString:
    mov al, 0
    .for:
        call lerChar ;lê o char e passa o al
        stosb   ;pega o caracter no al e coloca no endereço de memoria ondde di aponta
        cmp al, 13 ;chegou no enter?
        je .fim ;cabou string
        call printChar ;printa o caracter que nao eh \n
        jmp .for ;faz dnv
    .fim:
        dec di ;na ultima posição da string tava salvo o enter, aí a gente vai colocar o 0 no lugar
        mov al, 0
        stosb
contar:
    xor bx, bx
    .loop:
        lodsb
        cmp al, 0
        je .endloop
        add bx, 1
        jmp .loop
    .endloop:
        ret
comparaVermelho:
    lodsb
    cmp al, 'v'
    jne .errou
    lodsb
    cmp al, 'e'
    jne .errou
    lodsb
    cmp al, 'r'
    jne .errou
    lodsb
    cmp al, 'm'
    jne .errou
    lodsb
    cmp al, 'e'
    jne .errou
    lodsb
    cmp al, 'l'
    jne .errou
    lodsb
    cmp al, 'h'
    jne .errou
    lodsb
    cmp al, 'o'
    jne .errou
    lodsb
    cmp al, 0
    je .vermelho

    .errou:
        ret
    .vermelho:
        mov si, verm
        mov bl, 4
        jmp printaString2

    ret
comparaAmarelo:
    lodsb
    cmp al, 'a'
    jne .errou
    lodsb
    cmp al, 'm'
    jne .errou
    lodsb
    cmp al, 'a'
    jne .errou
    lodsb
    cmp al, 'r'
    jne .errou
    lodsb
    cmp al, 'e'
    jne .errou
    lodsb
    cmp al, 'l'
    jne .errou
    lodsb
    cmp al, 'o'
    jne .errou
    lodsb
    cmp al, 0
    je .amarelo

    .errou:
        ret
    .amarelo:
        mov si, amar
        mov bl, 14
        jmp printaString2
comparaAzul:
    lodsb
    cmp al, 'a'
    jne .errou
    lodsb
    cmp al, 'z'
    jne .errou
    lodsb
    cmp al, 'u'
    jne .errou
    lodsb
    cmp al, 'l'
    jne .errou
    lodsb
    cmp al, 0
    je .azul

    .errou:
        ret
    .azul:
        mov si, azul
        mov bl, 1
        jmp printaString2 
comparaVerde:
    lodsb
    cmp al, 'v'
    jne .errou
    lodsb
    cmp al, 'e'
    jne .errou
    lodsb
    cmp al, 'r'
    jne .errou
    lodsb
    cmp al, 'd'
    jne .errou
    lodsb
    cmp al, 'e'
    jne .errou
    lodsb
    cmp al, 0
    je .verde

    .errou:
        ret
    .verde:
        mov si, verd
        mov bl, 2
        jmp printaString2

printaString2:
    mov ah, 02h ;move o cursor pro inicio
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h

    .loop:
        lodsb
        cmp al, 'z' ;chegou no fim da string?
        je fim

        mov ah, 09h ;configurar(?) o caractere colorido
        mov al, al  ;al = letra
        mov bh, 0   ;bh = pagina???
        mov bl, bl  ;bl = cor
        mov cx, 1   ;cx = qnts caracteres ce vai imprimir
        int 10h

        call printChar

        mov ah, 02h ;move o cursor pra proxima posicao
        mov bh, 0
        mov dh, 0
        add dl, 1
        int 10h

        jmp .loop
start:
    xor ax, ax	;zera ax
	mov ds, ax	;zera ds
	
	mov AX, 0013h
    mov bh, 0
	mov bl, 47
	int 10h

    mov di, enta ;di aponta pro começo da string p/ usar
    call lerString
    mov si, enta ;si aposta pro começo da string
    call contar
    mov si, enta
    call comparaAzul
    mov si, enta
    call comparaVerde
    mov si, enta
    call comparaVermelho
    mov si, enta
    call comparaAmarelo
    jmp naoExiste

naoExiste: 
    mov si, nTem
    mov bl, 5
    jmp printaString2
fim:
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55