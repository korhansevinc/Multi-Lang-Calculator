use strict;
use warnings;

sub precedence {
    my ($op) = @_;
    return 2 if $op eq '*' || $op eq '/';
    return 1 if $op eq '+' || $op eq '-';
    return 0;
}

sub apply_operator {
    my ($values, $op) = @_;
    
    return "ERROR! Invalid expression." if @$values < 2;
    
    my $b = pop @$values;
    my $a = pop @$values;
    
    if ($op eq '+') {
        push @$values, $a + $b;
    } elsif ($op eq '-') {
        push @$values, $a - $b;
    } elsif ($op eq '*') {
        push @$values, $a * $b;
    } elsif ($op eq '/') {
        return "ERROR! Division by zero." if $b == 0;
        push @$values, $a / $b;
    } else {
        return "ERROR! Invalid expression.";
    }
    
    return;
}

sub evaluate_expression {
    my ($tokens) = @_;
    my @values;
    my @operators;
    
    foreach my $token (@$tokens) {
        if ($token =~ /^\d+(\.\d+)?$/) {
            push @values, $token;
        } elsif ($token eq '(') {
            push @operators, $token;
        } elsif ($token eq ')') {
            while (@operators) {
                my $op = pop @operators;
                last if $op eq '(';
                my $error = apply_operator(\@values, $op);
                return $error if $error;
            }
        } else {
            while (@operators && precedence($operators[-1]) >= precedence($token)) {
                my $error = apply_operator(\@values, pop @operators);
                return $error if $error;
            }
            push @operators, $token;
        }
    }
    
    while (@operators) {
        my $error = apply_operator(\@values, pop @operators);
        return $error if $error;
    }
    
    return @values == 1 ? $values[0] : "ERROR! Invalid expression.";
}

sub tokenize {
    my ($expression) = @_;
    my @tokens;
    my $current = '';
    
    foreach my $char (split //, $expression) {
        if ($char =~ /\s/) {
            next;
        } elsif ($char =~ /\d/ || $char eq '.') {
            $current .= $char;
        } else {
            push @tokens, $current if $current ne '';
            $current = '';
            push @tokens, $char;
        }
    }
    push @tokens, $current if $current ne '';
    
    return \@tokens;
}

while (1) {
    print "Enter an expression (or type 'exit' to quit):\n";
    my $input = <STDIN>;
    chomp $input;
    
    last if lc($input) eq 'exit';
    
    my $tokens = tokenize($input);
    my $result = evaluate_expression($tokens);
    
    print "Result: $result\n";
}

print "Program has been ended.\n";
