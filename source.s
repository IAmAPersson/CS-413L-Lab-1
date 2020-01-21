.data
.balign 4
arrA:
	.word 9, 23, -69, 420, 6, 0, -99, 66, 42, 1
arrB:
	.word 78, -23, 96, -600, 7, 10, 99, -67, 89, 123
arrC:
	.skip 40
inpval:
	.word 0
hellomsg:
	.asciz "Hello! I will add these two arrays together...\n"
arr1msg:
	.asciz "Array 1's values: "
arr2msg:
	.asciz "Array 2's values: "
arr3msg:
	.asciz "Sums: "
perd:
	.asciz "%d "
perc:
	.asciz "%c"
nl:
	.asciz "\n"
filtermsg:
	.asciz "Enter 'P' for positive, 'N' for negative, or 'Z' for zero, and I will output all values in the sum array that match that filter!\n"

.text
.equ elems, 10
.global main

main:
	LDR R0, =hellomsg
	PUSH { LR }
	BL printf
	POP { LR }

preploop:
	MOV R5, #10
	LDR R0, =arrA
	LDR R1, =arrB
	LDR R2, =arrC
addloop:
	LDR R3, [R0], #4
	LDR R4, [R1], #4
	ADD R3, R4
	STR R3, [R2], #4
	SUBS R5, #1
	BNE addloop

printarrs:
	LDR R0, =arr1msg
	MOV R1, #elems
	LDR R2, =arrA
	PUSH { LR }
	BL printarr
	LDR R0, =arr2msg
	MOV R1, #elems
	LDR R2, =arrB
	BL printarr
	LDR R0, =arr3msg
	MOV R1, #elems
	LDR R2, =arrC
	BL printarr
	POP { LR }

filter:
	LDR R0, =filtermsg
	PUSH { LR }
	BL printf
	POP { LR }
	LDR R0, =perc
	LDR R1, =inpval
	PUSH { LR }
	BL scanf
	POP { LR }
	LDR R0, =inpval
	LDR R0, [R0]
	CMP R0, #'P'
	BEQ positive
	CMP R0, #'N'
	BEQ negative
	CMP R0, #'Z'
	BEQ zero
	B filter

positive:
	MOV R0, #1
	B outputfilt

negative:
	MOV R0, #-1
	B outputfilt

zero:
	MOV R0, #0

outputfilt:
	

retplace:
	MOV R7, #1
	SVC 0


printarr:
	PUSH { R4-R6 }
	MOV R4, R0
	MOV R5, R1
	MOV R6, R2
	MOV R0, R4
	PUSH { LR }
	BL printf
	POP { LR }

printarrloop:
	LDR R0, =perd
	LDR R1, [R6], #4
	PUSH { LR }
	BL printf
	POP { LR }
	SUBS R5, #1
	BNE printarrloop

	LDR R0, =nl
	PUSH { LR }
	BL printf
	POP { LR }
	POP { R4-R6 }
	BX LR

sgn:
	CMP R0, #0
	MOVGT R0, #1
	MOVLT R0, #-1
	BX LR

.global printf
.global scanf
