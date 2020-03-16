org 0x7c00 
jmp 0x0000:start

data:
    pergunta1 db "Digite o tamanho da base: z", 27, 10, 0
    pergunta2 db "Digite o tamanho da altura: z", 29, 10, 0
    ctBase db 0
    ctAltura db 0
    aux db 0
start:
	mov AX, 0011h           ;modo video
    mov bh, 0
	mov bl, 5
	int 10h

    mov si, pergunta1       
    call printaPergunta     ;printo a primeira pergunta

    call leBase             ;leio o tamanho da base

    mov ah, 02h             ;passo pra proxima linha
    mov bh, 0
    mov dh, 1
    mov dl, 0
    int 10h

    mov si, pergunta2
    call printaPergunta     ;printo a segunda pergunta

    call leAltura

    mov ah, 02h             ;passo pra proxima linha
    mov bh, 0
    mov dh, 2
    mov dl, 0
    int 10h

    call printaBase

    call printaParedes

    mov ah, 02h             ;passo pra proxima linha
    mov bh, 0
    add dh, 1
    mov dl, 0
    int 10h

    call printaBase

    jmp fim 
printaPergunta:             ;printa a string pedindo a entrada
    .loop:
        lodsb
        cmp al, 'z'         ;marco o fim da string com z
        je .endloop

        mov ah, 0xe
        int 10h

        jmp .loop
    .endloop:
        ret                 ;volto pra start
leBase:
    mov ah, 0               ;leio o primeiro digito
	int 16h
    mov ah, 0xe
	int 10h

    sub al, '0'             ;subtraio o valor do caractere 0
    mov [ctBase], al        ;vai salvar o tamanho em ctBase

    mov ah, 0               ;leio o segundo digito ou o \n
	int 16h
    mov ah, 0xe
	int 10h

    cmp al, 13              ;se foi \n eu volto pra start
    je .volta

    sub al, '0'             ;se nao foi \n, foi o segundo digito
    mov [aux], al           ;salvo ele em aux

    mov al, [ctBase]        ;pego o valor do primeiro digito
    mov dl, 10               
    mul dl                  ;multiplico ele por 10

    add al, [aux]           ;somo o valor de aux
    mov [ctBase], al        ;e salvo em ctAltura

    mov ah, 0               ;agora leio o \n
	int 16h
    mov ah, 0xe
	int 10h

    .volta:
        ret
leAltura:
    mov ah, 0               ;leio o primeiro digito
	int 16h
    mov ah, 0xe
	int 10h

    sub al, '0'             ;subtraio o valor do caractere 0
    mov [ctAltura], al      ;vai salvar o tamanho em ctAltura

    mov ah, 0               ;leio o segundo digito ou o \n
	int 16h
    mov ah, 0xe
	int 10h

    cmp al, 13              ;se foi \n eu volto pra start
    je .volta

    sub al, '0'             ;se nao foi \n, foi o segundo digito
    mov [aux], al           ;salvo ele em aux

    mov al, [ctAltura]      ;pego o valor do primeiro digito
    mov dl, 10               
    mul dl                  ;multiplico ele por 10

    add al, [aux]           ;somo o valor de aux
    mov [ctAltura], al      ;e salvo em ctAltura
    
    mov ah, 0               ;agora leio o \n
	int 16h
    mov ah, 0xe
	int 10h

    .volta:
        ret
printaBase:
    xor bh, bh
    .loop:
        cmp bh, [ctBase]
        je .endloop

        mov al, 42
        mov ah, 0xe
	    int 10h
        
        add bh, 1

        jmp .loop
    .endloop:
        ret
printaParedes:
    xor ah, ah
    mov ah, 1
    sub [ctAltura], ah 
    sub [ctAltura], ah
    .loop:
        xor ah, ah
        cmp [ctAltura], ah 
        je .endloop

        mov ah, 02h             ;passo pra proxima linha
        mov bh, 0
        add dh, 1
        mov dl, 0
        int 10h

        call printaParede 

        xor ah, ah 
        mov ah, 1
        sub [ctAltura], ah
        
        jmp .loop
    .endloop:
        ret

printaParede:
    xor bh, bh
    add bh, 1

    mov al, 42
    mov ah, 0xe
	int 10h

    add bh, 1
    .loop:
        cmp bh, [ctBase]
        je .endloop

        mov al, 32
        mov ah, 0xe
	    int 10h
        
        add bh, 1

        jmp .loop
    .endloop:
        mov al, 42
        mov ah, 0xe
        int 10h
        ret
fim:    
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55