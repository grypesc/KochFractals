section	.data
	extern pixelArray
section	.text
	global paintPixel
	global drawLine
	global kochRecursion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

paintPixel:
	push ebp
	mov ebp, esp

	mov eax, [pixelArray]
	mov ecx, [ebp+8] ;x
	mov ebx, [ebp+12] ;y

	dec ecx
	dec ebx
	imul ebx, ebx, 3000
	lea ecx, [ecx +2*ecx]
	add eax, ebx
	add eax, ecx


	mov BYTE [eax], 0
	inc eax
	mov BYTE [eax], 0
	inc eax
	mov BYTE [eax], 0
	inc eax

	mov esp, ebp
  pop ebp
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawLine:
	push ebp
	mov ebp, esp

	push DWORD 1	;kx
	push DWORD 1	;ky
	push DWORD 0	;dx
	push DWORD 0	;dy
	push DWORD 0	;e
	push DWORD 0	;counter
	mov eax, [ebp+8]
	mov ebx, [ebp+16]
	cmp eax, ebx
	jle kx1	;x1<=x2
	mov [ebp-4], DWORD -1

kx1:
	mov eax, [ebp+12]
	mov ebx, [ebp+20]
	cmp eax, ebx
	jle ky1
	mov [ebp-8], DWORD -1
ky1:
	mov eax, [ebp+8]
	mov ebx, [ebp+16]
	sub eax, ebx
	cmp eax, 0
	jge dxIsCounted
	neg eax
dxIsCounted:
	mov [ebp-12], eax
	mov eax, [ebp+12]
	mov ebx, [ebp+20]
	sub eax, ebx
	cmp eax, 0
	jge dyIsCounted
	neg eax

dyIsCounted:
	mov [ebp-16], eax

	push DWORD [ebp+12]
	push DWORD [ebp+8]
	call paintPixel
	add esp, 8

	mov eax, [ebp-12]
	mov ebx, [ebp-16]
	cmp eax, ebx
	jl K16
	mov eax, [ebp-12]
	mov [ebp-20], eax
K08Loop:
	mov ecx, [ebp-24]
	cmp ecx, [ebp-12]
	jge drawLineExit

	mov eax, [ebp+8];K09
	add eax, [ebp-4]
	mov [ebp+8], eax

	mov eax, [ebp-20];K10
	sub eax, [ebp-16]
	sub eax, [ebp-16]
	mov [ebp-20], eax

	cmp eax, 0
	jge K14

	mov eax, [ebp+12];K12
	add eax, [ebp-8]
	mov [ebp+12], eax

	mov eax, [ebp-20];K13
	add eax, [ebp-12]
	add eax, [ebp-12]
	mov [ebp-20], eax

K14:
	push DWORD [ebp+12]
	push DWORD [ebp+8]
	call paintPixel
	add esp, 8

	mov ecx, [ebp-24]
	inc ecx
	mov [ebp-24], ecx

	jmp K08Loop

K16:
	mov eax, [ebp-16]
	mov [ebp-20], eax
K17Loop:
	mov ecx, [ebp-24]
	cmp ecx, [ebp-16]
	jge drawLineExit

	mov eax, [ebp+12];K18
	add eax, [ebp-8]
	mov [ebp+12], eax

	mov eax, [ebp-20];K19
	sub eax, [ebp-12]
	sub eax, [ebp-12]
	mov [ebp-20], eax

	cmp eax, 0
	jge K23

	mov eax, [ebp+8];K21
	add eax, [ebp-4]
	mov [ebp+8], eax

	mov eax, [ebp-20];K22
	add eax, [ebp-16]
	add eax, [ebp-16]
	mov [ebp-20], eax

K23:
	push DWORD [ebp+12]
	push DWORD [ebp+8]
	call paintPixel
	add esp, 8

	mov ecx, [ebp-24]
	inc ecx
	mov [ebp-24], ecx

	jmp K17Loop

drawLineExit:

	mov esp, ebp
  pop ebp
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kochRecursion:
	push ebp
	mov ebp, esp
	push esi
	mov esi, [ebp+24] ;esi contains recursion depth
	push DWORD 0
	push DWORD [ebp+20]
	push DWORD [ebp+16]
	push DWORD [ebp+12]
	push DWORD [ebp+8]
	call kochRecursionMain
	add esp, 20
kochRecursionEnd:
	pop esi
	mov esp, ebp
	pop ebp
	ret

kochRecursionMain:

	push ebp
	mov ebp, esp

	mov eax, [ebp+24]
	cmp eax, esi
	jge theDeepestLevel

	add esp, -24

	mov eax, [ebp+16];calculation of x3
	sub eax, [ebp+8]
	mov edx, 0
	cmp eax, 0
	jge nextx3
	mov edx, -1
nextx3:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3

	add eax, [ebp+8]
	mov [ebp-4], eax

	mov eax, [ebp+20];calculation of y3
	sub eax, [ebp+12]
	mov edx, 0
	cmp eax, 0
	jge nexty3
	mov edx, -1
nexty3:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	add eax, [ebp+12]
	mov [ebp-8], eax

	mov eax, [ebp+8];calculation of x4
	sub eax, [ebp+16]
	mov edx, 0
	cmp eax, 0
	jge nextx4
	mov edx, -1
nextx4:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	add eax, [ebp+16]
	mov [ebp-12], eax

	mov eax, [ebp+12];calculation of y4
	sub eax, [ebp+20]
	mov edx, 0
	cmp eax, 0
	jge nexty4
	mov edx, -1
nexty4:
	mov ebx, 3
	idiv ebx
	call roundDivisionby3
	add eax, [ebp+20]
	mov [ebp-16], eax


	mov ebx, [ebp-4];calculation of x5
	sub ebx, [ebp+8]
	mov eax, [ebp-8]
	sub eax, [ebp+12]

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
	add ebx, [ebp-4]
	mov [ebp-20], ebx


	mov eax, [ebp-4];calculation of y5
	sub eax, [ebp+8]
	mov ebx, [ebp-8]
	sub ebx, [ebp+12]

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
	add ebx, [ebp-8]
	mov [ebp-24], ebx


	mov eax, [ebp+24];points 1 and 3
	inc eax
	push DWORD eax
	push DWORD [ebp-8]
	push DWORD [ebp-4]
	push DWORD [ebp+12]
	push DWORD [ebp+8]
	call kochRecursionMain
	add esp, 20

	mov eax, [ebp+24]; points 2 and 4
	inc eax
	push DWORD eax
	push DWORD [ebp+20]
	push DWORD [ebp+16]
	push DWORD [ebp-16]
	push DWORD [ebp-12]
	call kochRecursionMain
	add esp, 20

	mov eax, [ebp+24]; points 3 and 5
	inc eax
	push DWORD eax
	push DWORD [ebp-24]
	push DWORD [ebp-20]
	push DWORD [ebp-8]
	push DWORD [ebp-4]
	call kochRecursionMain
	add esp, 20

	mov eax, [ebp+24]; points 4 and 5
	inc eax
	push DWORD eax
	push DWORD [ebp-16]
	push DWORD [ebp-12]
	push DWORD [ebp-24]
	push DWORD [ebp-20]
	call kochRecursionMain
	add esp, 20

	mov esp, ebp
	pop ebp
	ret


theDeepestLevel:
	push DWORD [ebp+20]
	push DWORD [ebp+16]
	push DWORD [ebp+12]
	push DWORD [ebp+8]
	call drawLine
	add esp, 16

	mov esp, ebp
	pop ebp
	ret

roundDivisionby3:
	push ebp
	mov ebp, esp

	cmp edx, 1
	jle next
	inc eax
next:
		mov esp, ebp
		pop ebp
		ret


divideBy2withRounding:
	push ebp
	mov ebp, esp

	cmp ebx, 2
	jp next2
	inc ebx
next2:
	sar ebx, 1

	mov esp, ebp
	pop ebp
	ret
