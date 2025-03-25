use std::io;
use std::collections::VecDeque;

#[derive(Debug)]
enum EvalError {
    DivisionByZero,
    InvalidExpression,
}

type EvalResult = Result<f64, EvalError>;

fn tokenize(expression: &str) -> Vec<String> {
    let mut tokens = Vec::new();
    let mut current = String::new();
    
    for c in expression.chars() {
        if c.is_whitespace() {
            continue;
        } else if c.is_ascii_digit() || c == '.' {
            current.push(c);
        } else {
            if !current.is_empty() {
                tokens.push(current.clone());
                current.clear();
            }
            tokens.push(c.to_string());
        }
    }
    if !current.is_empty() {
        tokens.push(current);
    }
    tokens
}

fn precedence(op: &str) -> i32 {
    match op {
        "*" | "/" => 2,
        "+" | "-" => 1,
        _ => 0,
    }
}

fn apply_operator(stack: &mut Vec<f64>, op: &str) -> EvalResult {
    if stack.len() < 2 {
        return Err(EvalError::InvalidExpression);
    }
    let b = stack.pop().unwrap();
    let a = stack.pop().unwrap();
    let result = match op {
        "+" => a + b,
        "-" => a - b,
        "*" => a * b,
        "/" => {
            if b == 0.0 {
                return Err(EvalError::DivisionByZero);
            }
            a / b
        }
        _ => return Err(EvalError::InvalidExpression),
    };
    stack.push(result);
    Ok(result)
}

fn evaluate_expression(tokens: Vec<String>) -> EvalResult {
    let mut values = Vec::new();
    let mut operators = VecDeque::new();
    
    for token in tokens {
        if let Ok(num) = token.parse::<f64>() {
            values.push(num);
        } else if token == "(" {
            operators.push_back(token);
        } else if token == ")" {
            while let Some(op) = operators.pop_back() {
                if op == "(" {
                    break;
                }
                apply_operator(&mut values, &op)?;
            }
        } else {
            while !operators.is_empty() && precedence(&operators.back().unwrap()) >= precedence(&token) {
                apply_operator(&mut values, &operators.pop_back().unwrap())?;
            }
            operators.push_back(token);
        }
    }
    
    while let Some(op) = operators.pop_back() {
        apply_operator(&mut values, &op)?;
    }
    
    if values.len() == 1 {
        Ok(values.pop().unwrap())
    } else {
        Err(EvalError::InvalidExpression)
    }
}

fn main() {
    loop {
        let mut input = String::new();
        println!("Enter an expression (or type 'exit' to quit):");
        io::stdin().read_line(&mut input).expect("Failed to read line");
        
        let input = input.trim();
        if input.eq_ignore_ascii_case("exit") {
            break;
        }
        
        let tokens = tokenize(input);
        match evaluate_expression(tokens) {
            Ok(result) => println!("Result: {}", result),
            Err(EvalError::DivisionByZero) => println!("ERROR! Division by zero."),
            Err(EvalError::InvalidExpression) => println!("ERROR! Invalid expression."),
        }
    }
}
