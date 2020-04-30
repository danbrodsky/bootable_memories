; "memories" by HellMood/DESiRE
; the tiny megademo, 256 byte msdos intro
; shown in April 2020 @ REVISION

; Partially converted to a boot sector

; GLOBAL PARAMETERS, TUNE WITH CARE!
%define instrument 11
%define scale_mod -19*32*4;
%define time_mask 7
%define targetFPS 35
%define tempo 1193182/256/targetFPS
%define sierp_color 0x2A
%define tunnel_base_color 20
%define tunnel_pattern 6
%define tilt_plate_pattern 4+8+16
%define circles_pattern 8+16

org 100h
s:
top:
	mov ax,0xcccd
	mul di
	add al,ah
	xor ah,ah
	add ax,bp
	shr ax,9
	and al,15
	xchg bx,ax
	mov bh,1
	mov bl,[byte bx+table]
	call bx
	stosb
	inc di
	inc di
	jnz top
	mov al,tempo
	out 40h,al
	in al,0x60
	dec al
	jnz top
sounds:
	db 0xc3	; is MIDI/RET
table: ; first index is volume, change order with care!
	db fx2-s,fx1-s,fx0-s,fx3-s,fx4-s,fx5-s,fx6-s,sounds-s,stop-s
stop:
	pop ax
	ret
fx0: ; tilted plane, scrolling
	mov ax,0x1329
	add dh,al
	div dh
	xchg dx,ax
	imul dl
	sub dx,bp
	xor ah,dl
	mov al,ah
	and al,tilt_plate_pattern
ret
fx2: ; board of chessboards
	xchg dx,ax
	sub ax,bp
	xor al,ah
	or al,0xDB
	add al,13h
ret
fx1: ; circles, zooming
	mov al,dh
	sub al,100
	imul al
	xchg dx,ax
	imul al
	add dh,ah
	mov al,dh
	add ax,bp
	and al,circles_pattern
ret
fx3: ; parallax checkerboards
	mov cx,bp
	mov bx,-16
fx3L:
	add cx,di
	mov ax,819
	imul cx
	ror dx,1
	inc bx
	ja fx3L
	lea ax,[bx+31]
ret
fx4: ; sierpinski rotozoomer
	lea cx,[bp-2048]
	sal cx,3
	movzx ax,dh
	movsx dx,dl
	mov bx,ax
	imul bx,cx
	add bh,dl
	imul dx,cx
	sub al,dh
	and al,bh
	and al,0b11111100
	salc				; VERY slow on dosbox, but ok
	jnz fx4q
	mov al,sierp_color
	fx4q:
ret
fx5: ; raycast bent tunnel
	mov cl,-9
	fx5L:
	push dx
		mov al,dh
		sub al,100
		imul cl
		xchg ax,dx
		add al,cl
		imul cl
		mov al,dh
		xor al,ah
		add al,4
		test al,-8
	pop dx
	loopz fx5L
	sub cx,bp
	xor al,cl
	aam tunnel_pattern; VERY slow on dosbox, but ok
	add al,tunnel_base_color
ret
fx6: ; ocean night / to day sky
	sub dh,120
	js fx6q
	mov [bx+si],dx
	fild word [bx+si]
	fidivr dword [bx+si]
	fstp dword [bx+si-1]
	mov ax,[bx+si]
	add ax,bp
	and al,128
	dec ax
fx6q:
ret

    times 510-($-$$) db 0
    db 0x55
    db 0xaa
