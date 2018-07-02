section	.data
	extern pixelArray
section	.text
	global paintPixel
	global drawLine
	global kochRecursion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

paintPixel:
	push rbp
	mov rbp, rsp

	mov eax, [pixelArray]
 	mov rcx, rdi
 	mov rbx, rsi

	dec ebx
	dec ecx

	imul ebx, ebx, 3000
	imul ecx, ecx, 3
	add eax, ebx
	add eax, ecx


	mov BYTE [eax], 0
	inc eax
	mov BYTE [eax], 0
	inc eax
	mov BYTE [eax], 0
	inc eax

	mov rsp, rbp
  pop rbp
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawLine:
	push rbp
	mov rbp, rsp

	push QWORD 1	;kx
	push QWORD 1	;ky
	push QWORD 0	;dx
	push QWORD 0	;dy
	push QWORD 0	;e
	push QWORD 0	;counter
	mov rax, rdi
	mov rbx, rdx
	cmp eax, ebx
	jle kx1	;x1<=x2
	mov QWORD [rbp-8], QWORD -1

kx1:
	mov rax, rsi
	mov rbx, rcx
	cmp eax, ebx
	jle ky1
	mov QWORD [rbp-16], QWORD -1
ky1:
	mov rax, rdi
	mov rbx, rdx
	sub eax, ebx
	cmp eax, 0
	jge dxIsCounted
	neg eax
dxIsCounted:
	mov [rbp-24], rax
	mov rax, rsi
	mov rbx, rcx
	sub eax, ebx
	cmp eax, 0
	jge dyIsCounted
	neg eax

dyIsCounted:
	mov [rbp-32], rax

	mov r10, rcx
	call paintPixel
	mov rcx, r10

	mov rax, [rbp-24]
	mov rbx, [rbp-32]
	cmp eax, ebx
	jl K16
	mov rax, [rbp-24]
	mov [rbp-40], rax
K08Loop:
	mov rax, [rbp-48]
	mov rbx, [rbp-24]
	cmp eax, ebx
	jge drawLineExit

	mov rax, rdi;K09
	add rax, [rbp-8]
	mov rdi, rax

	mov rax, [rbp-40];K10
	mov rbx, [rbp-32]
	sub eax, ebx
	sub eax, ebx
	mov [rbp-40], rax

	cmp eax, 0
	jge K14

	mov rax, rsi;K12
	mov rbx, [rbp-16]
	add eax, ebx
	mov rsi, rax

	mov rax, [rbp-40];K13
	mov rbx, [rbp-24]
	add eax, ebx
	add eax, ebx
	mov [rbp-40], rax

K14:
	mov r10, rcx
	call paintPixel
	mov rcx, r10

	mov rax, [rbp-48]
	inc eax

	mov [rbp-48], rax

	jmp K08Loop

K16:
	mov rax, [rbp-32]
	mov [rbp-40], rax
K17Loop:
	mov rax, [rbp-48]
	mov rbx, [rbp-32]
	cmp eax, ebx
	jge drawLineExit

	mov rax, rsi;K18
	mov rbx, [rbp-16]
	add eax, ebx
	mov rsi, rax

	mov rax, [rbp-40];K19
	mov rbx, [rbp-24]
	sub eax, ebx
	sub eax, ebx
	mov [rbp-40], rax

	cmp eax, 0
	jge K23

	mov rax, rdi;K21
	mov rbx, [rbp-8]
	add eax, ebx
	mov rdi, rax

	mov rax, [rbp-40];K22
	mov rbx, [rbp-32]
	add eax, ebx
	add eax, ebx
	mov [rbp-40], rax

K23:

	mov r10, rcx
	call paintPixel
	mov rcx, r10

	mov rax, [rbp-48]
	inc eax
	mov [rbp-48], rax

	jmp K17Loop

drawLineExit:

	mov rsp, rbp
  pop rbp
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kochRecursion:
	push rbp
	mov rbp, rsp

	mov r11, r8;r11 contains recursion depth
	push QWORD 0
	push QWORD rcx
	push QWORD rdx
	push QWORD rsi
	push QWORD rdi
	call kochRecursionMain
	add rsp, 40
kochRecursionEnd:

	mov rsp, rbp
	pop rbp
	ret

kochRecursionMain:

	push rbp
	mov rbp, rsp

	mov rax, [rbp+48]
	cmp rax, r11
	jge theDeepestLevel

	add rsp, -48

	mov rax, [rbp+32];calculation of x3
	mov rbx, [rbp+16]
	sub eax, ebx
	mov edx, 0
	cmp eax, 0
	jge nextx3
	mov edx, -1
nextx3:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	mov rbx, [rbp+16]
	add eax, ebx
	mov [rbp-8], rax

	mov rax, [rbp+40];calculation of y3
	mov rbx, [rbp+24]
	sub eax, ebx
	mov edx, 0
	cmp eax, 0
	jge nexty3
	mov edx, -1
nexty3:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	mov rbx, [rbp+24]
	add eax, ebx
	mov [rbp-16], rax


	mov rax, [rbp+16];calculation of x4
	mov rbx, [rbp+32]
	sub eax, ebx
	mov edx, 0
	cmp eax, 0
	jge nextx4
	mov edx, -1
nextx4:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	mov rbx, [rbp+32]
	add eax, ebx
	mov [rbp-24], rax

	mov rax, [rbp+24];calculation of y4
	mov rbx, [rbp+40]
	sub eax, ebx
	mov edx, 0
	cmp eax, 0
	jge nexty4
	mov edx, -1
nexty4:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	mov rbx, [rbp+40]
	add eax, ebx
	mov [rbp-32], rax

	mov rbx, [rbp-8];calculation of x5
	mov rax, [rbp+16]
	sub ebx, eax
	mov rax, [rbp-16]
	mov rcx, [rbp+24]
	sub eax, ecx

	imul eax, 866
	mov edx, 0
	cmp eax, 0
	jge nextx5
	mov edx, -1
nextx5:
	mov ecx, 1000
	idiv ecx
	cmp edx, 500
	jl mulHelp1
	inc eax
mulHelp1:
	call divideBy2withRounding
	sub ebx, eax
	mov rax, [rbp-8]
	add ebx, eax
	mov [rbp-40], rbx

	mov rax, [rbp-8];calculation of y5
	mov rbx, [rbp+16]
	sub eax, ebx
	mov rbx, [rbp-16]
	mov rcx, [rbp+24]
	sub ebx, ecx

	imul eax, 866
	mov edx, 0
	cmp eax, 0
	jge nexty5
	mov edx, -1
nexty5:
	mov ecx, 1000
	idiv ecx
	cmp edx, 500
	jl mulHelp2
	inc eax
mulHelp2:

	call divideBy2withRounding

	add ebx, eax
	mov rax, [rbp-16]
	add ebx, eax
	mov [rbp-48], rbx


	mov rax, [rbp+48];points 1 and 3
	inc rax
	push QWORD rax
	push QWORD [rbp-16]
	push QWORD [rbp-8]
	push QWORD [rbp+24]
	push QWORD [rbp+16]
	call kochRecursionMain
	add rsp, 40

	mov rax, [rbp+48];points 2 and 4
	inc rax
	push QWORD rax
	push QWORD [rbp+40]
	push QWORD [rbp+32]
	push QWORD [rbp-32]
	push QWORD [rbp-24]
	call kochRecursionMain
	add rsp, 40

	mov rax, [rbp+48];points 3 and 5
	inc rax
	push QWORD rax
	push QWORD [rbp-48]
	push QWORD [rbp-40]
	push QWORD [rbp-16]
	push QWORD [rbp-8]
	call kochRecursionMain
	add rsp, 40

	mov rax, [rbp+48];points 5 and 4
	inc rax
	push QWORD rax
	push QWORD [rbp-32]
	push QWORD [rbp-24]
	push QWORD [rbp-48]
	push QWORD [rbp-40]
	call kochRecursionMain
	add rsp, 40

	mov rsp, rbp
	pop rbp
	ret


theDeepestLevel:
	mov rdi, [rbp+16]
	mov rsi, [rbp+24]
	mov rdx, [rbp+32]
	mov rcx, [rbp+40]
	call drawLine
	add rsp, 32

	mov rsp, rbp
	pop rbp
	ret

roundDivisionby3:
	push rbp
	mov rbp, rsp

	cmp edx, 1
	jle next
	inc eax

next:
		mov rsp, rbp
		pop rbp
		ret

divideBy2withRounding:
	push rbp
	mov rbp, rsp

	cmp ebx, 2
	jp next2
	inc ebx
next2:
	sar ebx, 1

	mov rsp, rbp
	pop rbp
	ret
