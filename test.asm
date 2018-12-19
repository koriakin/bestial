mov r8, 0
mov r9, 0

loop:
readkbd r0

shr r1, r0, 4
cmp r1, 10
jc letter0
add r1, r1, 0x30
jmp print0
letter0:
add r1, r1, 0x41-10
print0:

putchar r8, r9, r1
add r8, r8, 1

mov r2, 0xf
and r1, r0, r2
cmp r1, 10
jc letter1
add r1, r1, 0x30
jmp print1
letter1:
add r1, r1, 0x41-10
print1:

bl r15, putc
jmp loop

putc:
putchar r8, r9, r1
add r8, r8, 1
cmp r8, 80
jnz ret
mov r8, 0
add r9, r9, 1
cmp r9, 25
jnz ret
mov r9, 0
ret:
br r14, 0
