# Library
A library is a group of pre-compiled coded, called functions, to avoid repetition of code, package is created, called library.
- Note: Library is not an executable.
## Static Library
### Introduction
A **static** library is a collection of object files that are linked together during the compilation phase of a program. Unlike dynamic libraries, static libraries are linked with the program at compile time, resulting in a single executable file that contains the code from both the program and the library.
### Steps
### 1. Write Your Functions
#### add.c
```
int add(int a, int b)
{
return a+b ;
}
```
#### sub.c
```
int sub (int a , int b )
{
return a - b ;
}
```
#### multiple.c
```
int sub (int a , int b )
{
return a * b ;
}
```
#### div.c
```
int sub (int a , int b )
{
return a / b ;
}
```
#### modulas.c
```
int modulas (int a , int b )
{
if (b==0)
{
return -1 ;
}
return a % b ;
}
```
### 2. Create Header file calc.h included
```
int add(int a,int b);
int sub(int a,int b);
int multiple(int a,int b);
int div(int a,int b);
int modulas(int a,int b);
```
### 3. Compile your functions to get .o files
```
gcc -c *.c 
```
### 4. Create the Static Library
```
ar rcs liboperation.a *.o
```
### 5. Write Your Source Code using the Static Library in the Code
```
#include <stdio.h>
#include "calc.h"

int main() {
    int a = 10, b = 5;
    printf("Addition: %d\n", add(a, b));
    printf("Subtraction: %d\n", sub(a, b));
    printf("Division: %d\n", div(a, b));
 
    return 0;
}
```
### 6. Compile main.c with the Static Library
```
gcc main.c -o main -L. liboperation.a
```
### 7. Run the Program
```
./main
```
## Dynamic Library
 - The Same Steps of writing **Source Code (main.c) and .c functions** and **Header file (calc.h)**
 - Get **.o files** as an output of .c functions
### Compile the Dynamic Library
Compile the source file into a shared object (dynamic library) using the `-shared` flag:
```bash
gcc -shared -fPIC -o liboperation.so *.c
```
The `-shared` flag indicates that you are creating a shared object, and `-fPIC` generates position-independent code, which is necessary for shared libraries.
### Compile Your Program with the Dynamic Library
Compile your program with the dynamic library:
```
gcc main.c -o main.elf -L. liboperation.so
```
Here, `-L.` tells the linker to look for libraries in the current directory, and `-lmylib` links your program with `libmylib.so`.
#### 5. Run Your Program
Execute the compiled program:
```bash
./mainelf
```
