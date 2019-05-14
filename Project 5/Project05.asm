TITLE Sorting Random Integers     (Project05.asm)

; Author: Brittany Dunn
; OSU email address: dunnbrit@oregonstate.edu
; Course number/section:CS271_400
; Project Number: 05                 Due Date: May 27 2018
; Description: This program will display programmer's name and program title, get the user's request in the range [10..200], generate random numbers in the range[100..999],
;				store the random numbers in an array, display the array, sort the array in descending order, calculate and display the median, and display the sorted array.


INCLUDE Irvine32.inc

 INT_MIN = 10
 INT_MAX = 200
 RAND_LO = 100
 RAND_HI = 999

.data

intro_program		BYTE	"Sorting Random Integers ",0
intro_programmer	BYTE	"by Brittany Dunn",0
description_1		BYTE	"This program generates 10-200 random numbers in the range [100..999].",0
description_2		BYTE	"The unsorted list is displayed, the median is calculated and displayed, the list is then displayed in descending order.",0
request				DWORD	?								;input from user
array				DWORD INT_MAX DUP(?)					;array with max size of int range (200)
sorted_title		BYTE	"The Sorted List: ",0				
unsorted_title		BYTE	"The Unsorted List: ",0
prompt_request		BYTE	"How many numbers should be generated? Please choose a number in the range [10-200]:   ",0
prompt_invalid		BYTE	"Input invalid. Please try again.",0
spaces				BYTE	"   ",0
median_message		BYTE	"The median is: ",0


.code
main PROC

push	OFFSET intro_program
push	OFFSET intro_programmer
push	OFFSET description_1
push	OFFSET description_2 
call	introduction

push	OFFSET prompt_request
push	OFFSET prompt_invalid
push	OFFSET request
call	getData

call	Randomize
push	OFFSET array
push	request
call	fillArray

push	OFFSET spaces
push	OFFSET unsorted_title
push	OFFSET array
push	request
call	displayList					;display unsorted list

push	OFFSET array
push	request
call	sortList

push	OFFSET median_message
push	OFFSET array
push	request
call	displayMedian

push	OFFSET spaces
push	OFFSET sorted_title
push	OFFSET array
push	request
call	displayList					;display sorted list

	exit	; exit to operating system
main ENDP

;Procedure to display program name and programmer's name
;recieves: address of intro_program,intro_programmer
;returns: none
;preconditions: none
;registers changed: EDX
introduction PROC
	push	ebp
	mov		ebp,esp
	mov		edx,[ebp+20]			;display intro_program
	call	WriteString
	mov		edx,[ebp+16]			;display intro_programmer
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx,[ebp+12]			;display description 1
	call	WriteString
	call	Crlf
	mov		edx,[ebp+8]				;display description 2
	call	WriteString
	call	Crlf
	call	Crlf
	pop		ebp
	ret		16
introduction ENDP


;Procedure to get user's request for number of random integers
;recieves: address of request_prompt, address of invalid_prompt, address of request varible
;returns: user input in request variable
;preconditions: request must be in the range [10..200]
;registers changed: edx,ebx,eax
getData PROC
	push	ebp
	mov		ebp,esp
	top:
		mov		edx,[ebp+16]
		call	WriteString
		call	ReadInt
		mov		ebx,[ebp+8]			;address of request
		mov		[ebx],eax			;store user input in request
		cmp		eax,INT_MIN			;check if input if greater than or equal to min
		jge		maxTest				;if greater than or equal to min go to max test
		mov		edx,[ebp+12]		
		call	WriteString			;if not display invalid message
		call	Crlf
		jmp		top					;return to top to get new input
	maxTest:
		cmp		eax,INT_MAX			;check if input is less than or equal to max
		jle		validInput			;if less than or equal to go to valid input
		mov		edx,[ebp+12]		
		call	WriteString			;if not display invalid message
		call	Crlf
		jmp		top					;return to top to get new input
	validInput:
		call	Crlf
		pop		ebp
		ret		12
getData ENDP


;Procedure to fill array with request number of random integers
;recieves: address of array, value of request
;returns: array with random integers stored in elements
;preconditions: random integers must be in the range [100..999], request must be in the range [10..200]
;registers changed: eax,esi
fillArray PROC
	push	ebp
	mov		ebp,esp
	mov		esi,[ebp+12]			; address of array in esi
	mov		ecx,[ebp+8]				; value of request is used to set loop counter
	addRandom:
		mov		eax,RAND_HI			; create range
		sub		eax,RAND_LO
		inc		eax
		call	RandomRange			; get random integer
		add		eax, RAND_LO		; put within range
		mov		[esi],eax			; move random integer into array element
		add		esi,4				; go to next element
		loop	addRandom			; loop for next number
	pop		ebp
	ret		8
fillArray ENDP


;Procedure to sort array in descending order
;recieves: address of array, value of request
;returns: sorted elements in array
;preconditions: random integers must be in the range [100..999], request must be in the range [10..200]
;registers changed: ecx,esi,eax,ebx
sortList PROC
	push	ebp
	mov		ebp,esp
	mov		ecx,[ebp+8]					; counter set to number of requests	
	dec		ecx
	loop1:
		push	ecx						; save loop counter
		mov		esi,[ebp+12]			; address of array
	loop2:	
		mov		eax,[esi]				; array[i]
		cmp		[esi+4],eax				; check if [i] is greater than [j]
		jle		loop3					; if [i] is greater than [j] then move to next element
		push	[esi+4]					; address of array[j]
		push	esi						; address of array[i]
		call	exchangeElements		; if not call exchangeElements to swap them in the array
	loop3:
		add		esi,4					; move to next element
		loop	loop2					; continue loop to sort the whole array
	pop		ecx							; restore loop counter
	loop	loop1						; continue loop to sort the whole array
	pop		ebp
	ret		8
sortList ENDP
				;Procedure to exchange elements of array 
				;recieves: address of array[i], address of array[j]
				;returns: swaped array elements i and j 
				;preconditions: i < j
				;registers changed: esi,eax,ebx
				exchangeElements PROC
					push	ebp
					mov		ebp,esp
					mov		esi,[ebp+8]			; address of array[i]
					mov		eax,[esi]			; array[i]
					mov		ebx,[ebp+12]		; array[j]
					xchg	eax,ebx				; swap array[i] and array[j] values
					mov		[esi],eax			; move value into array[i]
					mov		[esi+4],ebx			; move value into arrray[j]
					pop		ebp
					ret		8
				exchangeElements ENDP


;Procedure to calculate and display median
;recieves: address of array, value of request, address of median_message
;returns: none
;preconditions: random integers must be in the range [100..999], request must be in the range [10..200]
;registers changed: eax,ebx,esi,edx
displayMedian PROC
	push	ebp
	mov		ebp,esp
	mov		eax,[ebp+8]				; number of elements in eax
	mov		esi,[ebp+12]			; address of array
	mov		edx,0					; clear edx
	mov		ebx,2			
	div		ebx						; divide number of elements by 2
	cmp		edx,0					; check if there was a remainder
	je		evenMedian				; if no remainder go to evenMedian to calculate a median for even number of elements
	mov		ebx,4					; if odd get the middle element
	mul		ebx						; muliply by 4 to get address of middle element
	add		esi,eax				
	mov		ebx,[esi]				; store middle element value in ebx
	mov		eax,ebx					; move value to eax for display
	jmp		display_middle
	evenMedian:
		mov		ebx,4				; if even get the first middle element
		mul		ebx					; muliply by 4 to get address of first middle element 
		add		esi,eax
		mov		ebx,[esi]			; store first middle element value in ebx
		add		ebx,[esi-4]			; add second middle element to first middle element ;subtract 4 to get address of second middle element
		mov		eax,ebx				; move value to eax for division
		mov		ebx,2
		div		ebx					; divide by 2 to get average
	display_middle:
		call	Crlf
		mov		edx,[ebp+16]			
		call	WriteString			; display median message
		call	WriteDec			; display median
		call	Crlf
		call	Crlf

	pop		ebp
	ret		12
displayMedian ENDP


;Procedure to display the elements of the array
;recieves: value of request, address of list title(either sorted or unsorted), address of array, address of spaces
;returns: none
;preconditions: random integers must be in the range [100..999], request must be in the range [10..200]
;registers changed: ecx,esi,eax,edx,ebx
displayList PROC
	push	ebp
	mov		ebp,esp
	mov		esi,[ebp+12]			; address of array in esi
	mov		ecx,[ebp+8]				; value of request is used to set loop counter
	mov		ebx,0					; value of counter for lines
	mov		edx,[ebp+16]			; display list title
	call	WriteString			
	call	Crlf
	display:
		mov		eax,[esi]			; array element
		call	WriteDec			; display array element
		mov		edx,[ebp+20]
		call	WriteString			; display spaces
		add		esi,4				; move to next element
		inc		ebx					; increment 10 item line counter
		cmp		ebx,10				; check if line counter is at 10
		jne		continueDisplay		; if not at 10 continue displaying elements
		call	Crlf				; if at 10 go to new line
		mov		ebx,0				; reset counter to 0
	continueDisplay:
		loop	display				; loop back to display next element
	call	Crlf
	pop		ebp
	ret		16
displayList ENDP

END main
