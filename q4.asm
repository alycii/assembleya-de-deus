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

    call printaBase         ;printo a parte de cima do retangulo

    call printaParedes      ;printo as paredes

    mov ah, 02h             ;passo pra proxima linha
    mov bh, 0
    add dh, 1
    mov dl, 0
    int 10h

    call printaBase         ;printo a base

    jmp fim                 ;cabou
printaPergunta:             ;printa a string pedindo a entrada
    .loop:
        lodsb
        cmp al, 'z'         ;como eu marco o fim da string com z, eu faço essa comparação
        je .endloop

        mov ah, 0xe         ;se nao for z eu printo o caracter
        int 10h

        jmp .loop
    .endloop:
        ret                 ;volto pra start
leBase:
    mov ah, 0               ;leio o primeiro digito
	int 16h
    mov ah, 0xe             ;e printo
	int 10h

    sub al, '0'             ;subtraio o valor do caractere 0
    mov [ctBase], al        ;salvo o valor em ctBase

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

    add al, [aux]           ;somo o valor de aux ao valor q foi multiplicado por 10
    mov [ctBase], al        ;e salvo em ctAltura

    mov ah, 0               ;agora leio o \n
	int 16h
    mov ah, 0xe
	int 10h

    .volta:
        ret                 ;volto pra start
leAltura:
    mov ah, 0               ;leio o primeiro digito
	int 16h
    mov ah, 0xe
	int 10h

    sub al, '0'             ;subtraio o valor do caractere 0
    mov [ctAltura], al      ;salvo o tamanho em ctAltura

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
        cmp bh, [ctBase]    ;bh eh meu contador, se ele for igual ao tamanho da base
        je .endloop         ;entao eu ja printei tudo e paro o loop

        mov al, 42          ;se nao eu printo mais um *
        mov ah, 0xe
	    int 10h
        
        add bh, 1           ;incremento meu contador

        jmp .loop
    .endloop:
        ret                 ;volto p start
printaParedes:
    xor ah, ah
    mov ah, 1
    sub [ctAltura], ah      ;preciso subtrair 2 da altura
    sub [ctAltura], ah      ;pq as linhas teto/base já sao parte da altura

    .loop:
        xor ah, ah
        cmp [ctAltura], ah  ;se ctAltura eh 0 ja printei tudo
        je .endloop

        mov ah, 02h         ;passo pra proxima linha
        mov bh, 0
        add dh, 1
        mov dl, 0
        int 10h

        call printaParede   ;printo uma parede tipo:  *           *

        xor ah, ah 
        mov ah, 1
        sub [ctAltura], ah  ;decremento ctAltura
        
        jmp .loop
    .endloop:
        ret                 ;volto pra start

printaParede:
    xor bh, bh
    add bh, 1

    mov al, 42              ;printo o *
    mov ah, 0xe
	int 10h

    add bh, 1
    .loop:                  ;printo os espaços
        cmp bh, [ctBase]
        je .endloop

        mov al, 32          ;cansei de comentar
        mov ah, 0xe
	    int 10h
        
        add bh, 1

        jmp .loop
    .endloop:
        mov al, 42          ;printo o outro *
        mov ah, 0xe
        int 10h
        ret                 ;e volto pro start
fim:    
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55