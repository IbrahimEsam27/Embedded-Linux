# Makefile
## what is Make ?
 - Make is a scripting tool is used for building executable according to commands
 - Make tool parse an input file " Makefile"to define rules that it will run
 - two types of Make ( GNU Make - Borland Make)
## Why we need Make ?
 - to organize the compilation process
 - to run our tools and scripts
 - to automate the process
 - to be fully control on the outputs and its time
### Basic Syntax
1) setting rule 
```bash
 Target : prerequisites
<tab> Recipe
```
2) Define Variable
  ```make
 files = main.cpp
 files += hello.cpp
  ```
3) substitute variable 

  echo $(files)

4) Disaple Echo 
	  
    Using @ ex : 
  
  ```make
  @echo "hello"
  ```
5) Access Enviroment Variable
 
    it is accessible ex : 
  ```make
  echo $(PATH)
  ```
6) Access shell commands
	  
    example
  ```make
clean:
    @rm *.o
    @echo "`date` done" > log.txt
  ```
7) Access external scripts   
    example
  ```make
test:
	python3 analysis.py
  ```
### Functions in Makefile
```make
define Display
	@echo "Entering The Function"
	@echo "The function name is $0"
	@echo "The function first Argument is $1"
	@echo "The function Second Argument is $2"
	@echo "The Target name is $@"
endef
x := Esam
target1:
	$(call Display,Hema,$(x))
```
**``$0``** --> refers to Function Name

**``$1``** --> refers to First Argument of Function

**``$2``** --> refers to Second Argument of function

**``$@``** --> refers to Target Name , This is an automatic variable

### Builtin Functions examples
```make 
target2:
	@echo $(subst .c,.cpp, main.c led.c)
	@echo $(sort bar zoo hema)
	@echo $(word 3, hema toto vovo)
	@echo $(wordlist 2,3, cat dog bird)
```
**``subst``** --> to change main.c to main.cpp

**``sort``** --> to sort the words so it will be **``bar hema zoo``**

**``word``** --> to get specific word according index

**``wordlist``** --> to list specific words
### for Loop example
```make
LIST = one two three
loop1:
	@for i in $(LIST); do \
		echo $$i; \
	done
```
 - it will print Element of **LIST** so it will print **one two three**
### foreach Loop example
```make
LIST2 = bar var zar
list_2 = $(foreach i , $(LIST2),"\nword is $(i)")
loop2:
	@echo $(list_2)
```
**foreach** have three arguments 
 - **``i``** is the iterator
 - the second one is the container it iterates on , in our case variable **``LIST2``** 
 - the third Argument is the command executed for each object in the container, in this example it prints **``word is <object name>``**

### if Condition
#### example.1
```make
ifeq "$(file)" "test.c"
cond1:
	@echo "True"
endif
```
 - if the two variables are equal then print **true** 
 - int this case are equal beacause **$(file) file := test.c** is defined in **makeconfig** 
#### example.2 : ifdef Condition
```make
faza = hemaa
boo = faza
cond3:
ifdef $(boo)
	@echo "CONDITION3 is true"
endif
```
 - if there is a variable called **(boo)** and have value so the condition is **true**
### Include 
```make 
include makeconfig
build: compile
	@$(CC) $(file) -o runprogram
compile:
	@$(CC) -c $(file)
```
 - to include file **makeconfig** which have the variables definition used in the project
### .PHONY
```make
.PHONY : clean
```
 - if we have file called **clean** in our project and have task in the **Makefile** called **clean** so you have to use **.PHONY** to use the task called **clean** in the **Makefile**
### Automatic Variables
```make 
info1 : 
	@echo "Test version 1.1"
info2:
	@echo "Using $(CC)"
help: info1 info2
	@echo "This is $@"
	@echo "This is First Dependency $<"
	@echo "This is all Dependencies $^"

```
 - **``make help``** will result
 ```
    Test version 1.1
    Using gcc
    This is help
    This is First Dependency info1
    This is all Dependencies info1 info2
```
> In Makefiles, automatic variables are special variables that provide information about the current target, prerequisites, etc.

Here are some common automatic variables used in Makefiles:

- **`$@`**: Represents the target filename. It is used to refer to the target of the rule.
- **`$<`**: Represents the first prerequisite filename. It is used to refer to the first prerequisite of the rule.
- **`$^`**: Represents all the prerequisites filenames. It is used to refer to all the prerequisites of the rule.
- **`$?`**: Represents all the prerequisites that are newer than the target. It is used to refer to prerequisites that have changed since the target was last modified.
- **`$*`**: Represents the stem of the target filename. It is used to refer to the part of the filename without its suffix.

## Building Library project using Makefile
[Make Library](https://github.com/IbrahimEsam27/Embedded-Linux/tree/main/8-%20Makefile/Make_Library)

### Special Thanks to Eng. Moatasem-Elsayed
[Makefile Playlist](https://youtube.com/playlist?list=PLkH1REggdbJpmQKm8Nu-H8R81_-c00fpB&si=8L2GfDWdDweAoRTo)
