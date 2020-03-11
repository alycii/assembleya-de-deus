;nasm -f bin acm.asm -o acm.bin
;qemu-system-i386 -drive file=acm.bin,format=raw,index=0,media=disk

org 0x7c00 
jmp 0x0000:start

start:
	xor ax, ax
	mov ds, ax
	
	mov ah, 0
	mov al, 12h
	
	mov AX, 0011h
    mov bh, 0
	mov bl, 5
	int 10h

    push 1
	jmp leitura

leitura:
	mov ah, 0
	int 16h
    push AX
    cmp al, 13
    je escreveInvertido

	jmp escreve
escreve:
	mov ah, 0xe
	int 10h
	jmp leitura
escreveInvertido:
    pop AX
    cmp al, 1
    je fim

    mov ah, 0xe
    int 10h
    jmp escreveInvertido
fim:
	jmp $
	
times 510 - ($ - $$) db 0
dw 0xaa55