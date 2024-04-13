# Building Library with Makefile
```bash
mkdir Make_Library && mkdir Make_Library/lib
cd Make_Library
touch main.c makeconfig Makefile test.c test.h
cd lib
touch led.c led.h Makefile
```
#### led.c
```c
#include <stdio.h>
void ledon()
{ printf("Led is ON \n"); }
void ledoff()
{ printf("Led is OFF \n"); }
```
#### led.h
```c
void ledon();
void ledoff();
```
#### Makefile (in lib diresctory)
```make
createlib: led.o
	ar rcs libmylib.a led.h led.o
clean:
	@rm *.o
	@rm *.a
```
 - back to **Make_Library**
```bash
cd ..
```
#### makeconfig
```Go
file := test.c main.c
CC :=gcc
PATH_TO_OBJECT := "runprogram"
LIB_PATH =./lib 
```
#### main.c
```c
#include <stdio.h>
#include "test.h"
#include "led.h"

int main()
{
    Display();
    ledon();
    return 0;
}
```
#### test.c
```c
#include <stdio.h>

void Display()
{
    printf("Hello Hema from Display.c\n");
}
```
#### test.h
```c
void Display();
```
#### creating Makefile
```make
include makeconfig

# this command to execute the Makefile inside (LIB_PATH) 
# -C flag to go to speecific directory
createlib:
	@$(MAKE) -C $(LIB_PATH) $@
build: createlib
	$(CC) $(file) -I $(LIB_PATH) -lmylib -L $(LIB_PATH) -o runprogram

.PHONY: clean
clean:
	@if [ -e $(PATH_TO_OBJECT) ] ; \
	then \
		echo "File exists" ; \
		rm runprogram ; \
		$(MAKE) -C $(LIB_PATH) $@ ; \
	fi ;
```
#### Executing the project
```bash
make build
```
 - it will exeute **creatlib** first because it depends on it 
 - will create **led.o & libmylib.a** in **lib** directory && create **runprogram** in **Make_Library** Directory
#### Executing 
```bash
./runprogram
```
 - will print 
```
Hello Hema from Display.c
Led is ON
````