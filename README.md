# Bootable memories

## How to run:

`qemu-system-i386 -hda bootable_memories -vga std -device cirrus-vga`

## What is this?

I recently saw the awesome 256-byte DOS demo [Memories](http://www.sizecoding.org/wiki/Memories) by HellMood and was really impressed by how many effects could be fit into a minimal amount of code.
Unfortunately, the 100MB installation of DOS bloatware required to run this animation took away some of the beauty for me. So, after hacking away at the source assembly in QEMU and GDB, I've now made the demo (mostly) runnable on bare metal as a boot sector image.

## References

https://rwmj.wordpress.com/2019/12/08/pyrit-by-rrrola-incredible-raytracing-demo-as-a-qemu-bootable-disk-image/
http://www.sizecoding.org/wiki/Memories
