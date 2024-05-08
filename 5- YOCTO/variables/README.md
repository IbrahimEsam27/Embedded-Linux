# Variables 
### Commonly Used Variables

- **PN** (Package Name)
- **PV** (Package Version)
- **PR** (Package Revision)
- **WORKDIR** (Working Directory)
- **S** (Source)
- **D** (Destination)
- **B** (Build Directory)


### Declaring a Recipe
#### **``myrecipe_0.1_r0.bb``**

The bold part of the name, such as **"0.1"** denotes the specific version of the recipe, while **"r0"** represents the package revision.
Retrieving Variable Values

### How to read a Variable
```bash
## bitbake -e <RECIPE_NAME> | grep ^<VARIABLE_NAME>=
bitbake -e example | grep ^WORKDIR=
```

### (PN) Package Name
PN denotes the recipe name utilized by the Yocto build system to create a package. This name is derived from the recipe file name.

---
### (PV) Package Version
PV indicates the version of the recipe. Normally, the version is extracted from the recipe filename.

---
### (PR) Package Revision 
The revision of the recipe. The default value is “r0”

---
### (WORKDIR) Working Directory 
The WORKDIR is the directory where the Yocto build system constructs a recipe. This directory resides within the TMPDIR directory structure and is specific to the recipe and the target system.

---
### (S) Source 

S refers to the location in the Build Directory where the unpacked recipe source code is situated. By default, this directory is WORKDIR/BPN-PV, with BPN as the base recipe name and PV as the recipe version.

---
### Destination (D)
D indicates the destination directory, where components are installed by the do_install task. By default, this directory is WORKDIR/image.

**``bindir``** ---> usr/bin under image which will be installed in the tearget and have Executables 

---
### Build Directory (B)
It is identical to S.

# Variable Assignment

## Types of Variable Assignments

| Assignment | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| ?=         | Default value assignment, can be overridden.                 |
| ??=        | Weak default value assignment, can be overridden. If multiple assignments are made, the last one takes precedence. |
| =          | Simple variable assignment, requires quotation marks and spaces are significant. Variables are expanded at the end. |
| :=         | Immediate variable expansion, the value assigned is expanded immediately. |
| +=         | Appends a value to a variable, inserting a space between the current value and the appended value. Takes effect immediately. |
| =+         | Prepends a value to a variable, inserting a space between the current value and the prepended value. Takes effect immediately. |
| .=         | Appends a value to a variable without inserting a space between the current value and the appended value. Takes effect immediately. |
| =.         | Prepends a value to a variable without inserting a space between the current value and the prepended value. Takes effect immediately. |
| :append    | Appends a value to a variable without inserting a space between the current value and the appended value. Effects are applied at variable expansion time rather than immediately. |
| :prepend   | Prepends a value to a variable without inserting a space between the current value and the prepended value. Effects are applied at variable expansion time rather than immediately. |
| :remove    | Removes values from lists. All occurrences of the specified value are removed from the variable. |
---

### Assignment Type ?=

```sh
TEST ?= "foo"
TEST ?= "bar"
TEST ?= "val"
TEST ?= "var"
```
 **Final value: TEST="foo"** 
> **Explaination:**
> 
> **?** --> strong Assignment and between the  value it goes with the First Value **foo**
---
### Assignment Type ??=
```sh
TEST ??= "foo"
TEST ??= "bar"
TEST ??= "val"
TEST ??= "var"
```
**Final value: TEST="var"**
> **Explaination:**
> 
> **??** --> Weak Assignment and between the  value it goes with the Last Value **var**
```sh
TEST ??= "foo"
TEST ?= "bar"
TEST ?= "val"
TEST ??= "var"
```
**Final value: TEST="bar"** 
> **Explaination:**
> 
> **??** --> Weak Assignment 
> so we take **?=** and between the first value **bar** and the second value **val** it goes with the first Value 

---
### Assignment Type =

```sh
# Override
A ?= "foo"
A = "bar"
```
**Final value: A="bar"** 

#### Variable Expansion
```sh
A = "foo"
B = "${A}"
A = "bar"
```
**Final value: B="bar"** 
> **Explaination:**
> 
> **=** --> is lazy operator it executes at the end so **B=${last Value of A}** 

---
### Assignment Type :=

```sh
# Override
A ?= "foo"
A := "bar"
```
**Final value: A="bar"** 
#### Variable Expansion
A = "foo"
B := "${A}"
A = "bar"
**Final value: B="foo"** 
> **Explaination:** **(=:)** is an immediate expansion so it takes the value **foo**

---
### Assignment Type += and =+

```bash
# Spaces are added here Automatically

# Append
A = "foo"
A += "bar"
```
**Final value: A="foo bar"** 

---
### - Prepend =+
```bash
B = "foo"
B =+ "bar"
```
**Final value: B="bar foo"**

---
### - Append
```sh
A ?= "val"
A += "var"
```
**Final value: A="val var"**
```sh
A ??= "val"
A += "var"
```
**Final value: A="var"** 

### - Prepend
```sh
B ??= "val"
B =+ "var"
```
**Final value: B="var"**

---
### Assignment Type ( .= )

```shell
# No Spaces are added here
# Needs to add extra space

# Append
A = "foo"
A .= "bar"
```
**Final value: A="foobar"** 

### Prepend ( =. )
```sh
B = "foo"
B =. "bar"
```
**Final value: B="barfoo"**

---
### Assignment Type ( :append ), ( prepend ) and ( :remove )

```shell
# No Spaces are added here
# Needs to add extra space
# Parsed at the end

# Append
A = "foo"
A:append = "bar"
```
**Final value: A="foobar"**
### Append
```sh
A = "foo"
A:append = "bar"
A += "val"
```
**Final value: A="foo valbar"** 

### Append
```sh
A = "foo"
A:append = " bar"
```
**Final value: A="foo bar"**

---
### Prepend
```sh
A = "foo"
A:prepend = "bar"
```
**Final value: A="barfoo"** 

### Prepend
```sh
A = "foo"
A:prepend = "bar"
A =+ "val"
```
**Final value: A="barval foo"** 

### Prepend
```sh
A = "foo"
A:prepend = "bar "
```
**Final value: A="bar foo"** 

### remove
```sh
A = "foo bar"
A:remove = "foo"
```
**Final value: A=" bar"** 
```sh
A = "foo bar"
A:remove = "var"
A += "var"
```
**Final value: A=" foo bar val"** 

