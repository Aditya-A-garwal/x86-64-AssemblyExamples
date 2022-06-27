# x86-64-AssemblyExamples
This repository contains Assembly language examples for the x86-64 architecture (linux kernel). All programs have been written using Intel syntax and the NASM compiler has been used. More examples will be added with time. A makefile has been included for making the build process more convenient. The following targets are defined in the makefile -
- default - alias for assemble, link
- assemble - assembles a source file into an object file
- link - links the object file(s) into an executable
Specifics of the build process can be changed withing the makefile, and the user is encouraged to do so.
