;nasm -f bin acm.asm -o acm.bin
;qemu-system-i386 -drive file=acm.bin,format=raw,index=0,media=disk

org 0x7c00 
jmp 0x0000:start

hello db 'Hello, World!', 13, 10, 0

start:
	xor ax, ax
	mov ds, ax
	
	mov ah, 0
	mov al, 12h
	
	mov ah, 0xb
	mov bh, 0
	mov bl, 47
	int 10h
	
	mov AX, 0013h
	int 10h

	call leitura

leitura:
	mov ah, 0
	int 16h
	cmp al, 13
	je fim
	
	call escreve

escreve:
	mov ah, 0xe
	int 10h
	call leitura
	
fim:
	mov ah, 0xe
	mov bh, 0
	mov bl, 4
	int 10h
	jmp $
	
times 510 - ($ - $$) db 0
dw 0xaa55
