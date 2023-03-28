.686
.model flat
public swap_abs
.code

swap_abs PROC
	push ebp ; save contents of EBP on the stack
	mov ebp,esp ; copy contents of ESP to EBP
	push ebx ; save contents of EBX register

	; converting to absolute value
	mov ebx, [ebp+8] ; address of array 'array'
	mov ecx, [ebp+12] ; number of elements in the array
conversion_abs: 
	mov eax, [ebx]
	cmp eax, 0
	; compare if the element is greater than 0
	jg no_change 
	neg eax
no_change:
	mov [ebx], eax 
	add ebx, 4 ; increase the index of the element
	loop conversion_abs

	mov ebx, [ebp+8] ; address of array 'array'
	mov ecx, [ebp+12] ; number of elements in the array
	dec ecx
	; assign the next element of the array to register EAX
loop_start: 
	mov eax, [ebx]
	cmp eax, [ebx+4]
	jle done ; jump if no swapping is needed
	; swap adjacent elements of the array
	mov edx, [ebx+4]
	mov [ebx], edx
	mov [ebx+4], eax
done:
	add ebx, 4 ; determine the address of the next element
	loop loop_start ; organize the loop

	pop ebx ; restore register contents
	pop ebp
	ret ; return to the main program
swap_abs ENDP

END