@ CS 413L Lab 1
@ Phil Lane
@ 1/22/2020
@ This software will add two arrays and filter according to sign.

.data
.balign 4
arrA:
	.word 2, 23, -69, 420, 6, 6, -99, 66, -89, 1
arrB:
	.word 78, -23, 96, -100, 7, 10, 99, -67, 89, -1
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
	BL printf @print the hello message

preploop:
	MOV R5, #10
	LDR R0, =arrA
	LDR R1, =arrB
	LDR R2, =arrC @load all three arrays into memory
addloop: @loop to add the arrays
	LDR R3, [R0], #4
	LDR R4, [R1], #4
	ADD R3, R4
	STR R3, [R2], #4 @add the arrays using post-autoindexing
	SUBS R5, #1
	BNE addloop @continue the loop

printarrs:
	LDR R0, =arr1msg
	MOV R1, #elems
	LDR R2, =arrA
	BL printarr @print array A
	LDR R0, =arr2msg
	MOV R1, #elems
	LDR R2, =arrB
	BL printarr @print array B
	LDR R0, =arr3msg
	MOV R1, #elems
	LDR R2, =arrC
	BL printarr @print array C

filter:
	LDR R0, =filtermsg
	BL printf @output the filter message
	LDR R0, =perc
	LDR R1, =inpval
	BL scanf @input what to filter
	LDR R0, =inpval
	LDR R0, [R0]
	CMP R0, #'P' @compare with positive
	BEQ positive
	CMP R0, #'N' @compare with negative
	BEQ negative
	CMP R0, #'Z' @compare with zero
	BEQ zero
	B filter @repeat if there were no matches (error checking)

positive:
	MOV R7, #1 @establish a positive filter
	B outputfilt

negative:
	MOV R7, #-1 @establish a negative filter
	B outputfilt

zero:
	MOV R7, #0 @establish a zero filter

outputfilt:
	LDR R4, =arrC
	MOV R5, #elems @load array C and its length
outputfiltloop: @loop to output numbers in the filter
	LDR R6, [R4], #4
	MOV R0, R6
	BL sgn
	CMP R0, R7 @compare the sign of the element to the filter
	LDR R0, =perd
	MOV R1, R6
	BLEQ printf @print it if the signs are equal
	SUBS R5, #1 @subtract 1 from the counter
	BNE outputfiltloop @continue the loop

	LDR R0, =nl
	BL printf @print a newline

retplace:
	MOV R7, #1 @ret
	SVC 0


printarr:
	PUSH { R4-R6, LR }
	MOV R4, R0
	MOV R5, R1
	MOV R6, R2
	MOV R0, R4 @move all arguments out of registers r0-r3 and move in the output message
	BL printf @print the output message

printarrloop: @begin the loop to print an array
	LDR R0, =perd
	LDR R1, [R6], #4
	BL printf @print all of the numbers in the array
	SUBS R5, #1 @subtract 1 from the counter
	BNE printarrloop @continue the loop

	LDR R0, =nl
	BL printf @print a newline
	POP { R4-R6, PC }
	BX LR @ret

sgn:
	CMP R0, #0
	MOVGT R0, #1 @move in 1 if r0>0
	MOVLT R0, #-1 @move in -1 if r0<0
	MOV PC, LR @otherwise r0=0, so do nothing, and return

.global printf
.global scanf
