org 0x7c00 
jmp 0x0000:start

data:
    ans db "aaaaaaaaaaa", 13, 10, 0 ;salvo 11 as porque no caso max n = 10 eu vou ter tipo:
    ct db 0                         ;"SNSNNNSSSNa" e vou parar de printar qnd chegar no a
start:
	mov AX, 0011h       ;modo video
    mov bh, 0
	mov bl, 5
	int 10h

    push 1              ;fim da pilha eh marcado pelo 1

    mov ah, 0           ;vai ler e printar o numero de casos (primeiro digito)
	int 16h
    mov ah, 0xe
	int 10h

    sub al, '0'         ;subtraio o valor do caractere 0
    add al, 1
    mov [ct], al        ;vai salvar o numero de casos em ct

    mov ah, 0           ;ler o \n ou o 0 do 10
    int 16h
    mov ah, 0xe
    int 10h

    cmp al, '0'         ;se foi o 0, agr a gente vai ler o barraN
    je .barraN
                        ;se foi o /n
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
        jmp lerCt       ;vou ler os casos testes

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
        je .endloop     ;caso tenha acabado termino o loop

        jmp lerEnt      ;vou ler a string

        jmp .loop       ;repito o loop, na vdd ele nunca nem chega aq pq eu nao dou nem um ret, mas fodase
    .endloop:
        jmp printaAns   ;vou printar as respostas
lerEnt:
    .loop:
        mov ah, 0           ;leio um caracter
        int 16h
        cmp al, 13          ;se foi /n termino o loop
        je .endloop

        mov ah, 0xe         ;se nao foi /n eu imprimo o caracter na tela
        int 10h 

        cmp al, '('         ;parenteses abrindo vai pra pilha
        je empilhaP
        cmp al, ')'
        je desempilhaP      ;parenteses fechando eu vou ver se eu tenho o correspondente
        cmp al, '['
        je empilhaP
        cmp al, ']'         ;qualquer outro caracter, como espaço, letra, etc, eh ignorado
        je desempilhaP2
        cmp al, '{'
        je empilhaP
        cmp al, '}'
        je desempilhaP3

        jmp .loop           ;e continuo o loop
    .endloop:
        mov ah, 0xe         ;printo o /n
        int 10h
        jmp achaFim         ;salvo minha resposta desse caso teste na string de resposta
empilhaP:
    push ax             ;coloca o parenteses abrindo na pilha
    jmp lerEnt
desempilhaP:
    pop ax              ;pego o topo da pilha

    cmp al, 1           ;se o topo da pilha eh 1 entao quer dizer que eu nao tenho 
    je .aux1            ;o parentese abrindo portanto está desbalanceado

    cmp al, '('         ;se eu tiver outro tipo de parentese
    jne .aux            ;também está errado

    jmp lerEnt          ;se o parentese for certo, eu tirei ele da pilha e vou voltar a ler a entrada

    .aux1:
        push 1          ;coloco de volta o 1 que nao pode sair de la
        mov al, 'w'     ;marco que deu errado
        push ax
        jmp lerEnt
        
    .aux:
        mov al, 'w'     ;coloco isso na pilha pq tipo se eu deixar o outro parentese
        push ax         ;pode ser q apareça o par dele e eu ia pensar q deu certo
        jmp lerEnt      ;pq a pilha estaria vazia, aí eu coloco uma letra random
desempilhaP2:
    pop ax

    cmp al, 1           ;se o topo da pilha eh 1 entao quer dizer que eu nao tenho 
    je .aux1            ;o parentese abrindo portanto está desbalanceado

    cmp al, '['         ;se eu tiver outro tipo de parentese
    jne .aux            ;também está errado

    jmp lerEnt          ;se o parentese for certo, eu tirei ele da pilha e vou voltar a ler a entrada
    
    .aux1:     
        push 1          ;coloco de volta o 1 que nao pode sair de la
        mov al, 'w'     ;marco que deu errado
        push ax 
        jmp lerEnt
    .aux:
        mov al, 'w'     ;coloco isso na pilha pq tipo se eu deixar o outro parentese
        push ax         ;pode ser q apareça o par dele e eu ia pensar q deu certo
        jmp lerEnt      ;pq a pilha estaria vazia, aí eu coloco uma letra random
desempilhaP3:
    pop ax

    cmp al, 1           ;se o topo da pilha eh 1 entao quer dizer que eu nao tenho 
    je .aux1            ;o parentese abrindo portanto está desbalanceado

    cmp al, '{'         ;se eu tiver outro tipo de parentese
    jne .aux            ;também está errado

    jmp lerEnt          ;se o parentese for certo, eu tirei ele da pilha e vou voltar a ler a entrada

    .aux1:
        push 1          ;coloco de volta o 1 que nao pode sair de la
        mov al, 'w'     ;marco que deu errado
        push ax 
        jmp lerEnt
     
    .aux:
        mov al, 'w'     ;coloco isso na pilha pq tipo se eu deixar o outro parentese
        push ax         ;pode ser q apareça o par dele e eu ia pensar q deu certo
        jmp lerEnt      ;pq a pilha estaria vazia, aí eu coloco uma letra random
achaFim:
    mov si, ans             ;coloco si apontando pro começo da string resposta
    xor bx, bx              ;zero bx pq ele vai contar onde eu tenho q colocar a prox resposta
    .loop:
        lodsb               ;percorro a string
        cmp al, 'a'
        je salvaResp        ;o primeiro 'a' que eu encontro eh o a do lugar q eu vou escrever
        add bx, 1
        jmp .loop           ;se n achei o a, incremento bx e continuo procurando
salvaResp:

    mov di, ans             ;movo di pro começo da string resposta
    add di, bx              ;coloco ele na posição q devia tar

    pop ax                  ;pego o topo da pilha
    cmp al, 1       
    je .correto             ;se a pilha tiver vazia entao eh pq deu tudo certo

    .loop:                  ;se ela n tava vazia, ai a gente precisa tirar o lixo
        pop ax              ;mas ja sabe q ta desbalanceada 
        cmp al, 1
        je .errado          ;entao vai pro errado
        jmp .loop           ;faz o loop ate a pilha ficar vazia
    
    .errado:
        mov al, 78          ;salvo a letra N na respectiva posicao
        stosb

        xor bx, bx          ;se eu tiro isso o negocio buga
        add bx, 1           ;NAO SEI PORQUE SOCORRO

        push 1              ;resetando a pilha
        jmp lerCt           ;continuando a leitura do prox caso teste

    .correto: 
        mov al, 83          ;salvo a letra S na respectiva posicao
        stosb 

        xor bx, bx           ;NAO SEI PORQUE NAO FUNCIONA SEM ISSO SOCORRO
        add bx, 1
        
        push 1              ;resetando a pilha
        jmp lerCt           ;continuando a leitura do prox caso teste
printaAns:
    mov si, ans             ;vou pro começo da string resposta
    .loop:
        lodsb
        cmp al, 'a'         ;se achei o 'a' acabou
        je .endloop

        mov ah, 02h         ;colocando o cursor na próxima linha
        mov bh, 0
        add dh, 1
        mov dl, 0
        int 10h

        mov ah, 0xe         ;printando a resposta (1 unico caracter pq to testando)
        int 10h

        jmp .loop           ;repetindo
    .endloop:
        jmp fim
fim:    
    jmp $
times 510 - ($ - $$) db 0
dw 0xaa55