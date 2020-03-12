org 0x7c00
jmp 0x0000:start 
data:
    enta db 20, 0, 0
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
comparaString:
    add si, 3
    lodsb

    cmp al, 'l'
    je .azul

    cmp al, 'r'
    je .amarelo

    cmp al, 'd'
    je .verde

    cmp al, 'm'
    je .vermelho

    .nada:
        mov si, nTem
        mov bl, 5
        jmp printaString2
    .azul:
        mov si, azul
        mov bl, 1
        jmp printaString2

    .amarelo:
        mov si, amar
        mov bl, 14
        jmp printaString2

    .verde:
        mov si, verd
        mov bl, 2
        jmp printaString2
    
    .vermelho:
        mov si, verm
        mov bl, 4
        jmp printaString2

    ret
; FUNCIONA NAO MEXER
printaString:
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    mov si, enta
    .loop:
        lodsb
        cmp al, 0 ;chegou no fim da string?
        je .endloop
        call printChar
        jmp .loop
    .endloop:
        ret    
; FUNCIONA??????? TALVEZ
printaString2:
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    .loop:
        lodsb
        cmp al, 'z';chegou no fim da string?
        je fim

        mov ah, 09h
        mov al, al
        mov bh, 0
        mov bl, bl
        mov cx, 1
        int 10h
        call printChar
        mov ah, 02h
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
fim:
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55