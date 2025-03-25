% Entry point
start :-
    write('Welcome to the Prolog Expression Calculator!'), nl,
    write('Type "exit." to quit.'), nl,
    expression_loop.

% Main expression loop
expression_loop :-
    write('Enter a mathematical expression (e.g., (2+1)*4-6):'), nl,
    read(Input),
    handle_input(Input).

% Handle input logic
handle_input(exit) :-
    write('Goodbye!'), nl, !.

handle_input(Input) :-
    valid_expression(Input),
    evaluate(Input),
    ask_continue.

handle_input(_) :-
    write('Invalid expression. Try again.'), nl,
    expression_loop.

% Evaluate and print result
evaluate(Input) :-
    catch(
        (   
            % Try to evaluate the expression
            Result is Input,
            format_result(Result)
        ),
        Error,
        handle_error(Error)
    ).

% Format and print the result
format_result(Result) :-
    write('Result: '),
    write(Result), nl.

% Handle errors
handle_error(error(evaluation_error(_, _), _)) :-
    write('Error: Invalid operation, such as division by zero or an undefined expression.'), nl.

handle_error(Error) :-
    write('An unexpected error occurred: '), write(Error), nl.

% Ask if the user wants to continue
ask_continue :-
    write('Do you want to continue? (y/n):'), nl,
    read(Answer),
    handle_continue_answer(Answer).

% Handle the user's answer to continue or exit
handle_continue_answer(y) :-
    nl, expression_loop.

handle_continue_answer('Y') :-
    nl, expression_loop.

handle_continue_answer(n) :-
    write('Goodbye!'), nl.

handle_continue_answer('N') :-
    write('Goodbye!'), nl.

handle_continue_answer(_) :-
    write('Invalid input. Assuming you want to continue.'), nl,
    expression_loop.

% Check if input is a valid arithmetic expression
valid_expression(Expr) :-
    ground(Expr),           % Make sure it’s a fully instantiated term
    Expr \= true,           % Rejects just typing "true."
    \+ var(Expr),           % Reject uninstantiated variables
    Expr =.. [Op, _, _],    % Decompose the expression
    member(Op, ['+', '-', '*', '/']).  % Check if the operator is one of these

:- initialization(start).
