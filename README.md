# Multi-Language Calculator

This project is a simple calculator implemented in five different programming languages: **Perl, Ada, Prolog, Rust, and Scheme**. The goal is to demonstrate the implementation of basic arithmetic operations across different paradigms and syntaxes.


## Description

The calculator supports fundamental arithmetic operations such as addition, subtraction, multiplication, and division. Each implementation follows the conventions and best practices of its respective language, ensuring idiomatic and efficient code. It can also answer compound expressions such as ((10 + 8*7)- (90 / 10))


## Implementation Details
The calculator in each language is designed to evaluate compound arithmetic expressions provided by the user via the terminal. The implementation ensures correct operator precedence and supports standard arithmetic operations such as addition (`+`), subtraction (`-`), multiplication (`*`), and division (`/`).

To achieve this, each implementation follows a structured approach:

1. **Parsing Input:** The program reads the arithmetic expression from the user as a string. Depending on the language, it may use regular expressions, tokenization, or built-in parsing utilities to break down the expression into meaningful components.

2. **Expression Evaluation:** A recursive or iterative approach is used to evaluate the parsed expression while respecting operator precedence and parentheses. Some implementations may utilize stacks (for operators and operands), while others use recursive descent parsing or built-in evaluation functions.

3. **Error Handling:** The calculator detects and handles errors such as:
   - **Invalid Syntax:** Unrecognized characters or misplaced operators.
   - **Division by Zero:** Prevents runtime errors by displaying an appropriate message.
   - **Mismatched Parentheses:** Ensures that every opening parenthesis has a corresponding closing parenthesis.
   
   Note: The Scheme implementation does **not** include explicit error handling.

4. **Result Output:** After successful evaluation, the result is displayed back to the user. If an error occurs (except in Scheme), the program provides a meaningful error message instead of crashing.

For example, given the expression:
```
(2 + 3 * (7 - 4) + 5 * 39)
```
Each implementation correctly computes and returns the expected result.


## How to Run the Code

Each implementation has specific requirements and execution steps. Below are the instructions for running the calculator in each language.


### Perl
**Requirements:**
- Perl installed on your system. If it is not you can install it by typing the following command in your terminal on Ubuntu
```sh
sudo apt install perl
```
To check if it is already installed, use the following command :
```sh
perl -v
```

**Run:**
- You can simply use the following command to run the perl calculator.
```sh
perl perlCalculator.pl
```
And you are good to go !


### Ada
**Requirements:**
- GNAT Ada compiler installed. If it is not you can install it by typing the following command in your terminal on Ubuntu
```sh
sudo apt install gnat
```
To check if it is already installed, use the following command :
```sh
gnat --version
```


**Compile & Run:**
- You can simply use the following command to run the perl calculator.
```sh
gnatmake adaCalculator.adb
./adaCalculator
```
And you are good to go !


### Prolog
**Requirements:**
- SWI-Prolog installed. If it is not you can install it by typing the following command in your terminal on Ubuntu
```sh
sudo apt install swi-prolog
```
To check if it is already installed, use the following command :
```sh
swipl --version
```

**Run:**
- First start the prolog
```sh
swipl
```
- After that run the calculator file by using the following line. (Do not forget the .(dot) at the end of the line ! And also while giving input to the program, make sure that using that '.' at the very end of your input. )
```sh
[prologCalculator.pl].
```
And you are good to go !


### Rust
**Requirements:**
- Rust toolchain installed. If it is not you can install it by typing the following command in your terminal on Ubuntu
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
After that finish the installing process and please reopen your terminal at the $pwd.
To check if it is already installed you can use the following line of command :
```sh
rustc --version
```

**Compile & Run:**
```sh
rustc rustCalculator.rs
./rustCalculator
```
And you are good to go !


### Scheme
**Requirements:**
- GNU Guile or another Scheme interpreter installed If it is not you can install it by typing the following command in your terminal on Ubuntu
```sh
sudo apt-get install mit-scheme
```
To check if it is already installed, you can use the following line of command :
```sh
mit-scheme --version
```

**Run:**
```sh
mit-scheme
(load "schemeCalculator.scm")
(calculator '(your expressions here) )
```
- Important Limitation : To use an odd # of number, you need to use parenthesis. And there is not an error handling for this particular language. An example of usage is down below :
```sh
(calculator '(27 - 49 + 6 * 30) )
(calculator '(27 - 49 + (6)))
```
And you are good to go !


## Author
Korhan Sevinç  
TOBB University of Economics and Technology

