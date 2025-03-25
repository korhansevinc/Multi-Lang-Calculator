with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Exceptions; use Ada.Exceptions;

procedure Float_Calculator is
    Division_By_Zero_Error : exception;
    Invalid_Expression_Error : exception;

    procedure Skip_Spaces(S : String; Index : in out Integer) is
    begin
        while Index <= S'Last and then (S(Index) = ' ' or S(Index) = ASCII.HT) loop
            Index := Index + 1;
        end loop;
    end Skip_Spaces;

    function Parse_Number(S : String; Index : in out Integer) return Float is
        Start          : constant Integer := Index;
        Integer_Part   : Float := 0.0;
        Fractional_Part : Float := 0.0;
        Fractional_Digs : Natural := 0;
        Has_Decimal    : Boolean := False;
    begin
        
        while Index <= S'Last and then Is_Digit(S(Index)) loop
            Integer_Part := Integer_Part * 10.0 + 
                Float(Character'Pos(S(Index)) - Character'Pos('0'));
            Index := Index + 1;
        end loop;

        
        if Index <= S'Last and then S(Index) = '.' then
            Has_Decimal := True;
            Index := Index + 1;
            
            
            while Index <= S'Last and then Is_Digit(S(Index)) loop
                Fractional_Part := Fractional_Part * 10.0 + 
                    Float(Character'Pos(S(Index)) - Character'Pos('0'));
                Fractional_Digs := Fractional_Digs + 1;
                Index := Index + 1;
            end loop;
        end if;

        
        if Index = Start or else (Has_Decimal and then Fractional_Digs = 0) then
            raise Invalid_Expression_Error with "Invalid number at position " & 
                Integer'Image(Index);
        end if;

        
        return Integer_Part + (Fractional_Part / 10.0 ** Fractional_Digs);
    end Parse_Number;

    function Evaluate_Expression(S : String; Index : in out Integer) return Float;
    function Evaluate_Term(S : String; Index : in out Integer) return Float;
    function Evaluate_Factor(S : String; Index : in out Integer) return Float;

    function Evaluate_Factor(S : String; Index : in out Integer) return Float is
        Result : Float;
    begin
        Skip_Spaces(S, Index);
        if Index > S'Last then
            raise Invalid_Expression_Error with "Unexpected end of expression";
        end if;

        if S(Index) = '(' then
            Index := Index + 1;
            Result := Evaluate_Expression(S, Index);
            Skip_Spaces(S, Index);
            if Index > S'Last or else S(Index) /= ')' then
                raise Invalid_Expression_Error with "Missing closing parenthesis";
            end if;
            Index := Index + 1;
        else
            Result := Parse_Number(S, Index);
        end if;
        return Result;
    end Evaluate_Factor;

    function Evaluate_Term(S : String; Index : in out Integer) return Float is
        Result : Float := Evaluate_Factor(S, Index);
        Op     : Character;
    begin
        loop
            Skip_Spaces(S, Index);
            exit when Index > S'Last;
            Op := S(Index);
            if Op = '*' or Op = '/' then
                Index := Index + 1;
                declare
                    Right : constant Float := Evaluate_Factor(S, Index);
                begin
                    if Op = '*' then
                        Result := Result * Right;
                    else
                        if Right = 0.0 then
                            raise Division_By_Zero_Error;
                        end if;
                        Result := Result / Right;
                    end if;
                end;
            else
                exit;
            end if;
        end loop;
        return Result;
    end Evaluate_Term;

    function Evaluate_Expression(S : String; Index : in out Integer) return Float is
        Result : Float := Evaluate_Term(S, Index);
        Op     : Character;
    begin
        loop
            Skip_Spaces(S, Index);
            exit when Index > S'Last;
            Op := S(Index);
            if Op = '+' or Op = '-' then
                Index := Index + 1;
                declare
                    Right : constant Float := Evaluate_Term(S, Index);
                begin
                    if Op = '+' then
                        Result := Result + Right;
                    else
                        Result := Result - Right;
                    end if;
                end;
            else
                exit;
            end if;
        end loop;
        return Result;
    end Evaluate_Expression;

    function Evaluate(Expression : String) return Float is
        Index : Integer := Expression'First;
        Result : Float;
    begin
        Skip_Spaces(Expression, Index);
        if Index > Expression'Last then
            raise Invalid_Expression_Error with "Empty expression";
        end if;
        Result := Evaluate_Expression(Expression, Index);
        Skip_Spaces(Expression, Index);
        if Index <= Expression'Last then
            raise Invalid_Expression_Error with "Unexpected characters after expression";
        end if;
        return Result;
    end Evaluate;

    Input_Expression : String(1..100);
    Input_Length     : Natural;
    Continue         : Character := 'y';
    Result           : Float;
begin
    while Continue = 'y' or Continue = 'Y' loop
        Put("Enter an expression (e.g., (2+4)*5/3): ");
        Get_Line(Input_Expression, Input_Length);
        
        begin
            Result := Evaluate(Input_Expression(1..Input_Length));
            Put("Result: ");
            Ada.Float_Text_IO.Put(Result, Fore => 1, Aft => 5, Exp => 0);
            New_Line;
        exception
            when Division_By_Zero_Error =>
                Put_Line("Error: Division by zero");
            when Error : Invalid_Expression_Error =>
                Put_Line("Error: " & Exception_Message(Error));
        end;

        Put("Do you want to continue? (y/n): ");
        Ada.Text_IO.Get(Continue);
        Ada.Text_IO.Skip_Line;
    end loop;
end Float_Calculator;
