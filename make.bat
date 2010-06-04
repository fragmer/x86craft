nasm -f win32 -Ox x86craft.asm
nasm -f win32 -Ox net.asm
nasm -f win32 -Ox world.asm
nasm -f win32 -Ox player.asm
nasm -f win32 -Ox config.asm
nasm -f win32 -Ox file.asm
nasm -f win32 -Ox console.asm
link /NOLOGO /NODEFAULTLIB /ENTRY:x86craft /SUBSYSTEM:CONSOLE /MACHINE:X86 ^
x86craft.obj ^
net.obj ^
world.obj ^
player.obj ^
config.obj ^
file.obj ^
console.obj ^
kernel32.lib ^
user32.lib ^
ws2_32.lib
del *.obj
