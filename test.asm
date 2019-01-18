mov r8, 0
mov r9, 0
mov r10, 0

loop:
readkbd r0

mov r4, 0
sethi r4, 0x120
stb r4, 0, r10
add r10, r10, 1

shr r1, r0, 4
cmp r1, 10
jc letter0
add r1, r1, 0x30
jmp print0
letter0:
add r1, r1, 0x41-10
print0:

bl r15, putc

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
mov r1, 0x20
bl r15, putc
jmp loop

putc:
shl r3, r9, 7
or r3, r3, r8
mov r4, 0
sethi r4, 0x100
or r3, r3, r4
stb r3, 0, r1
add r8, r8, 1
cmp r8, 80
jnz ret
mov r8, 0
add r9, r9, 1
cmp r9, 25
jnz ret
mov r9, 0
ret:
br r15, 0
