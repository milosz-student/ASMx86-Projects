.686
.model flat

public _weighted_average

.data
	one dd 1.0
	zero dd 0.0
	number_of_elements dd 0.0
.code

_weighted_average PROC
	push ebp
	mov ebp,esp
	pusha

	mov ecx,[ebp+16] ; size of the array
	mov esi,[ebp+12] ; address of weights array
	mov edi,[ebp+8] ; address of numbers array

	finit
	xor edx,edx ; iterator through the arrays

	fld dword ptr [zero]
counter:
	fld dword ptr [esi+edx] ;load weight
	fld dword ptr [edi+edx] ;load number
	fmulp  ;multiply value on the top of the stack
	faddp ;add value
	add edx,4
	loop counter
	;now the numerator is on top of the coprocessor stack

	xor edx,edx
	mov ecx,[ebp+16]
	fld dword ptr [zero]

denominator:
	fld dword ptr [esi+edx]
	faddp
	add edx,4
	loop denominator
	;now the denominator is on top of the coprocessor stack
	fdivp ;divide numerator/denominator
	;the result is on the top of the coprocessor stack st(0)

	popa ;restore all registers

	pop ebp
	ret
_weighted_average ENDP
END
