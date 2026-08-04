#!/bin/sh

x86_64-w64-mingw32-gcc -shared patch.c minhook/src/buffer.c minhook/src/hook.c minhook/src/trampoline.c minhook/src/hde/hde64.c \
                       -Os -static-libgcc -o obsidian.dll
strip --strip-all -R .note -R .comment obsidian.dll

x86_64-w64-mingw32-gcc -Wl,--subsystem,windows launch.c -Os -static -static-libgcc -lshlwapi -o obsidian.exe
strip --strip-all -R .note -R .comment obsidian.exe

x86_64-w64-mingw32-gcc -shared patch.c minhook/src/buffer.c minhook/src/hook.c minhook/src/trampoline.c minhook/src/hde/hde64.c \
                       -Os -static-libgcc -DOBSIDIAN_VST -lshlwapi -o obsidian-vst.vst3
strip --strip-all -R .note -R .comment obsidian-vst.vst3

x86_64-w64-mingw32-gcc -shared patch.c minhook/src/buffer.c minhook/src/hook.c minhook/src/trampoline.c minhook/src/hde/hde64.c \
                       -Os -static-libgcc -DOBSIDIAN_ARA -lshlwapi -o obsidian-ara.vst3
strip --strip-all -R .note -R .comment obsidian-ara.vst3

rm -f obsidian.zip
zip -9 obsidian.zip README.txt obsidian.dll obsidian-vst.vst3 obsidian-ara.vst3 obsidian.exe install-vst3-ara.bat uninstall-vst3-ara.bat

rm -f obsidian-src.zip
zip -9 obsidian-src.zip README.txt obsidian.dll obsidian-vst.vst3 obsidian-ara.vst3 obsidian.exe install-vst3-ara.bat uninstall-vst3-ara.bat patch.c launch.c minhook/src/buffer.c minhook/src/hook.c \
       minhook/src/trampoline.c minhook/src/hde/hde64.c minhook/include/MinHook.h minhook/src/buffer.h minhook/src/hde/hde64.h \
       minhook/src/hde/pstdint.h minhook/src/hde/table64.h minhook/src/trampoline.h build.sh clean.sh
