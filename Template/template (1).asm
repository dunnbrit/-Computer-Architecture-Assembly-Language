TITLE Program Template     (template.asm)

; Author:
; Last Modified:
; OSU email address: 
; Course number/section:
; Project Number:                 Due Date:
; Description:

INCLUDE Irvine32.inc

mReadStr MACRO varName
push ecx
push edx
mov edx,OFFSET varName
mov ecx,SIZEOF varName
call ReadString
pop edx
pop ecx
ENDM

.data
firstName BYTE 30 DUP(?)

.code
main PROC
mReadStr firstName

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
