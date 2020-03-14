org 0x7c00 
jmp 0x0000:start

data:
    ans db "a", 10, 10, 0
    ct db 0
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

    mov ah, 0           ;ler o \n ou o 0 do 10
    int 16h
    mov ah, 0xe
    int 10h

    cmp al, '0'         ;se foi o 0, agr a gente vai ler o barraN
    je .barraN

    mov dh, 0           ;zero o dh pra usar na contagem de linha dps
    jmp lerCt           ;vou ler as entradas
    
    .barraN:
        add al, 11      ;salvo que sao 10 entradas
        sub al, '0'     ;eu coloco 11 pq eu ja comeco decrementando no loop ai precisa ter 1 a mais
        mov [ct], al

        mov ah, 0       ;leio o \n
        int 16h
        mov ah, 0xe     ;e imprimo
        int 10h

        mov dh, 0       ;zero o dh p usar na contagem de linha
        jmp lerCt       ;vou ler as entras

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

        jmp .loop
    .endloop:
        jmp printaAns
lerEnt:
    .loop:
        mov ah, 0       ;leio um caracter
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
    push ax             ;coloca o parenteses abrindo na pilha
    jmp lerEnt
desempilhaP:
    pop ax

    cmp al, 1           ;se o topo da pilha eh 1 entao quer dizer que eu nao tenho 
    je .aux        ;o parentese abrindo portanto está desbalanceado

    cmp al, '('         ;se eu tiver outro caracter
    jne salvaNao        ;também está errado

    jmp lerEnt
    .aux:
        push 1
        jmp salvaNao
salvaNao:               ;a ideia era salvar cada resposta no seu indice
    mov al, 78         ;mas nao ta funfando
    mov di, ans
    stosb
    jmp lerEnt
printaAns:              ;fiz pra debugar o salvaNao
    mov si, ans
    lodsb

    mov ah, 02h         ;colocando o cursor na próxima linha
    mov bh, 0
    add dh, 1
    mov dl, 0
    int 10h

    mov ah, 0xe         ;printando a resposta (1 unico caracter pq to testando)
	int 10h
fim:
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55