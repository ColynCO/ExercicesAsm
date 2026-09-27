EXTERN cos:PROC
EXTERN sin:PROC

.code
asm_findTen PROC
	mov eax, -1
	mov r10d, edx

top:
	test edx, edx
	jz done

	movsxd r9, DWORD PTR [rcx]

	add rcx, 4
	dec edx

	cmp r9, r8
	jne top

	sub r10d, edx
	dec r10d
	mov eax, r10d

	; end of the loop
done:
	ret
asm_findTen ENDP

;void asm_addPoint(Shape* _shape, Point _newPoint);
asm_addPoint PROC

	xor r9, r9

	; new point index
	mov r8, QWORD PTR [rcx]			; point arr Pointer
	mov r9d, DWORD PTR [rcx + 8]	; size
	imul r9d, 12

	movss xmm0,  DWORD PTR[rdx]
	movss DWORD PTR[r8 + r9]	, xmm0

	movss xmm0,  DWORD PTR[rdx + 4]
	movss DWORD PTR[r8 + r9 + 4], xmm0

	movss xmm0,  DWORD PTR[rdx + 8]
	movss DWORD PTR[r8 + r9 + 8], xmm0

	inc DWORD PTR [rcx + 8]

	ret
asm_addPoint ENDP

;extern "C" double asm_sin(double _val);
asm_sin PROC
	call sin
	ret
asm_sin ENDP

;extern "C" float asm_fsin(float _val);
asm_fsin PROC
	sub rsp, 40
	cvtss2sd xmm0, xmm0
	call sin
	cvtsd2ss xmm0, xmm0
	add rsp, 40
	ret
asm_fsin ENDP

;extern "C" float asm_fcos(float _val);
asm_fcos PROC
	sub rsp, 40
	cvtss2sd xmm0, xmm0
	call cos
	cvtsd2ss xmm0, xmm0
	add rsp, 40
	ret
asm_fcos ENDP

;extern "C" double asm_cos(double _val);
asm_cos PROC
	call cos
	ret
asm_cos ENDP

;extern "C" void asm_rotateShapeYaw(Shape* _shape, float _rotation);
asm_rotateShapeYaw PROC
	; Shadowspace
	push rbx
	push rsi
	sub rsp, 16         
	movdqu [rsp], xmm6  
	sub rsp, 16         
	movdqu [rsp], xmm7  
	sub rsp, 56
											;rcx = shape address
											;xmm1 = _rotation

	mov rbx, QWORD PTR [rcx]				;point arr Pointer
	mov edx, DWORD PTR [rcx+8]				;edx = point count
	test edx, edx							;is edx 0
	jle done
	
	xor rsi, rsi

	movss xmm6, xmm1

	cvtss2sd xmm0, xmm6						; store rotation
	call sin	
	cvtsd2ss xmm7, xmm0						;xmm7 = sin(rotation)

	cvtss2sd xmm0, xmm6
	call cos								;xmm3 = cos(rotation)	
	cvtsd2ss xmm3, xmm0

	movss xmm4, DWORD PTR [rbx + rsi]		; x
	movss xmm5, DWORD PTR [rbx + rsi + 8]	; z
	top:
											; point data
	movss xmm4, DWORD PTR [rbx + rsi]		; x
	movss xmm5, DWORD PTR [rbx + rsi + 8]	; z
											; transform x
		mulps xmm4, xmm3					; x * cos
		mulps xmm5, xmm7					; z * sin
											; xmm0 = xcos - zsin
		movss xmm0, xmm4
		subps xmm0, xmm5
	
	movss xmm4, DWORD PTR [rbx + rsi]		; x
	movss xmm5, DWORD PTR [rbx + rsi + 8]	; z
	
	movss DWORD PTR [rbx + rsi], xmm0		; replace x
	
		mulps xmm4, xmm7					; xsin
		mulps xmm5, xmm3					; zcos
											; transform z
											; xmm0 = zcos + xsin
		movss xmm0, xmm4
		addps xmm0, xmm5
	
											
	movss DWORD PTR [rbx + rsi + 8], xmm0	; replace z
	
	add rsi, 12								; increase offset
	dec edx									; decrease counter
	cmp edx, 0								; loop if counter > 0
	jg top
	
	done:
	add rsp, 56
	movdqu xmm7, [rsp]  
	add rsp, 16    
	movdqu xmm6, [rsp]  
	add rsp, 16    
	pop rsi
	pop rbx

	ret
asm_rotateShapeYaw ENDP


END
