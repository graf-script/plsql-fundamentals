----------- PL/SQL FUNDAMENRALS --------------

/*
    Basics
    Procedures
    Cursors
    Functions
    Triggers
    Exception
*/
-- Hello World base
DECLARE
    message VARCHAR2(20) := 'Hello World!';
BEGIN
    dbms_output.put_line(message);
END;

-- get function example
SELECT * FROM departments;
SELECT e.first_name, e.last_name, get_depar_title(department_id) department_name FROM employees;
/

CREATE FUNCTION get_depar_title(p_depar_id IN NUMBER) RETURN VARCHAR2 IS
    v_depar_title VARCHAR2(100);
BEGIN
    SELECT d.department_name
    INTO v_depar_title
    FROM departments d
    WHERE d.departments d
    WHERE d.department_id = p_depar_id;

    RETURN v_depar_title;
END get_depar_title;
/

SELECT get_depar_title(40) department_title FROM dual;

DROP FUNCTION get_depar_title;

CREATE OR REPLACE FUNCTION totalEmployees
RETURN NUMBER IS
    total NUMBER(5) := 0;
BEGIN
    SELECT COUNT(*) INTO total
    FROM employees;

    RETURN total;
END;
/
DECLARE
    c NUMBER(5);
BEGIN
    c := totalEmployees();
    dbms_output.put_line('Total number of employees is: ' || c);
END;
/
-- loop example
DECLARE
    i NUMBER(1);
    j NUMBER(1);
BEGIN
    -- << outer loop >>
    FOR i IN 1..3 LOOP
        -- << inner loop >>
        FOR j IN 1..3 LOOP
        dbms_output.put_line('i is:' || i || ' and j is: ' || j);
        END LOOP;
    END LOOP;
END;
/

DECLARE 
    i NUMBER(1);
BEGIN
    FOR i IN 1..3 LOOP
    dbms_output.put_line('i is: ' || i);
    END LOOP;
END;
/

DECLARE
    i NUMBER(1); -- global var
BEGIN
    DECLARE
        v_word VARCHAR2(10) := 'Ukraine'; -- local var
    BEGIN
        FOR i IN 1..5 LOOP
            dbms_output.put_line(
                'Glory to ' || v_word
            );
        END LOOP;
    END;
END;
/

-- string type 
DECLARE
    names VARCHAR2(20);
    company VARCHAR2(30);
    introduction CLOB;
    choice CHAR(1);
BEGIN
    names := 'Kyrylo Makhnovskyi';
    company := 'Tenet';
    introduction := 'Hello, im ' || names || ' from ' || company || '.';
    choice := 'y';

    IF choice = 'y' THEN
        dbms_output.put_line(names);
        dbms_output.put_line(company);
        dbms_output.put_line(introduction);
    END IF;
END;
/

------- string functions ------------------

DECLARE
    greetings VARCHAR2(30) := 'hello world';
BEGIN
    dbms_output.put_line(greetings);
    -- uppercase
    dbms_output.put_line( UPPER(greetings) );

    -- lowercase
    dbms_output.put_line( LOWER(greetings) );

    -- Hello world
    dbms_output.put_line( INITCAP(greetings) );

    -- first letter
    dbms_output.put_line( SUBSTR(greetings, 1, 1) );

    -- last letter
    dbms_output.put_line( SUBSTR(greetings, -1, 1) );

    -- location letter
    dbms_output.put_line( INSTR(greetings, 'e') );
END;
/

DECLARE
    greetings VARCHAR2(50) := '.......... hello world ..........';
BEGIN
    -- right trim
    dbms_output.put_line( RTRIM(greetings, '.') );

    -- left trim
    dbms_output.put_line( LTRIM(greetings, '.') );

    -- all sides trim
    dbms_output.put_line( TRIM('.' FROM greetings ) );
END;
/

-------- SELECT ... INTO program--------------------
-- count employees which age < 41

DECLARE
    count_emp NUMBER;
    gender    VARCHAR2(10);
    hire_date DATE;
BEGIN
    SELECT COUNT(*)
        INTO count_emp
        FROM employees
        WHERE age < 41;
    dbms_output.put_line('Employees younger than 41: ' || count_emp);
END;
/

---------- VARRAY -----------

DECLARE
    TYPE typeARRAY is VARRAY(4) OF VARCHAR2(15);
    myARRAY1 typeARRAY := typeARRAY('John', 'Peter', 'Jenny');
    myARRAY2 typeARRAY;
BEGIN
    myARRAY2 :=  myARRAY1;
    dbms_output.put_line(myARRAY2(1));
    dbms_output.put_line(myARRAY2(2));
    dbms_output.put_line(myARRAY2(3));
END;
/

DECLARE
    i NUMBER(1);
    TYPE typeARRAY is VARRAY(4) of VARCHAR2(15);
    myARRAY1 typeARRAY := typeARRAY('John', 'Peter', 'Jenny', 'Kyrylo');
    myARRAY2 typeARRAY;
    options CHAR(1);
BEGIN
    options := 'y';
    myARRAY2 := myARRAY1;

    IF options = 'y' THEN
        FOR i IN 1..4 LOOP
            dbms_output.put_line( myARRAY2(i) );
        END LOOP;
    END iF;
END;
/

------------- PROCEDURE ---------------------

/*
    SCHEMA:

    CREATE OR REPLACE PROCEDURE procedure_name
        [ (param [, param, ...]) ] IS
        [local declare]
    BEGIN
        program
    [EXCEPTION]
    END [procedure_name];

*/
 
-- CREATE PROCEDURE

CREATE OR REPLACE PROCEDURE test_proc(
    par1 NUMBER := 10,
    par2 OUT NUMBER,
    par3 IN OUT NUMBER
)
IS
    t VARCHAR2(50) := 'test1';
    r NUMBER;
BEGIN
    t := 'test';
    r := 11;

    par2 := par1 * r;
    par3 := par2 + par1;
EXCEPTION
    WHEN OTHERS THEN RAISE;
END;
/

-- USING PROCEDURE
DECLARE
    p2 NUMBER;
    p3 NUMBER;
BEGIN
    test_proc(11, p2, p3);
    dbms_output.put('p2 = ');
    dbms_output.put_line(p2);
    dbms_output.put('p3 = ');
    dbms_output.put_line(p3);
END;
/

CREATE OR REPLACE PROCEDURE greetings
AS
BEGIN
    dbms_output.put_line('Hello world!');
END;
/
BEGIN
    greetings;
END;
/

-- Пример режима IN & OUT 1 
-- Эта программа находит минимум двух значений. Здесь процедура берет два числа, используя режим IN, и возвращает их минимум, используя параметры OUT.
DECLARE
    a number;
    b number;
    c number;

    PROCEDURE findMin(x IN number, y IN number, z OUT NUMBER) IS
    BEGIN
        IF x < y THEN
            z := x;
        ELSE
            z := y;
        END IF;
    END;
BEGIN
    a := 23;
    b := 45;
    findMin(a, b, c);
    dbms_output.put_line('Minimum of ' || a || ', ' || b || ' is ' || c);
END;
/

DECLARE
    a NUMBER;
    PROCEDURE squareNum(x IN OUT NUMBER) IS
    BEGIN
        x := x * x;
    END;
BEGIN
    a := 23;
    squareNum(a);
    dbms_output.put_line(' Square of  23 is ' || a);
END;
/

-- procedures records
-- table records
DECLARE 
    employee_rec employees%rowtype;
BEGIN
    SELECT * INTO employee_rec
    FROM employees
    WHERE id = 5;
    dbms_output.put_line('Emploiee ID ' || employee_rec.id);
    dbms_output.put_line('Emploiee Name ' || employee_rec.full_name);
    dbms_output.put_line('Emploiee Department ' || employee_rec.business_unit);
    dbms_output.put_line('Emploiee Salary ' || employee_rec.annual_salary);
END;
/

-- cursor records
DECLARE
    CURSOR employee_cur IS
        SELECT id, full_name, business_unit
        FROM employees;
    employee_rec employee_cur%rowtype;
BEGIN
    OPEN employee_cur;
    LOOP
        FETCH employee_cur INTO employee_rec;
        EXIT WHEN employee_cur%notfound;
        dbms_output.put_line(employee_rec.id || ' ' || employee_rec.full_name);
    END LOOP;
END;
/

-- users records

/*
TYPE 
type_name IS RECORD 
  ( field_name1  datatype1  [NOT NULL]  [:= DEFAULT EXPRESSION], 
   field_name2   datatype2   [NOT NULL]  [:= DEFAULT EXPRESSION], 
   ... 
   field_nameN  datatypeN  [NOT NULL]  [:= DEFAULT EXPRESSION); 
record-name  type_name;
*/

-- declare books record

DECLARE
TYPE books IS RECORD
(
    title VARCHAR2(50),
    author VARCHAR2(50),
    subject VARCHAR2(100),
    book_id NUMBER(2)
);
book1 books;
book2 books;
BEGIN
    -- book 1 records
    book1.title := 'JavaScript Programming';
    book1.author := 'John Mueich';
    book1.subject := 'Learn JavaScript Programming';
    book1.book_id := 12;

    -- book 2 records
    book2.title := 'SQL Queries';
    book2.author := 'Abim Jadhham';
    book2.subject := 'Study Oracle SQL';
    book2.book_id := 56;

    -- print book 1 record 
    dbms_output.put_line('Book 1 title: ' || book1.title);
    dbms_output.put_line('Book 1 author: ' || book1.author);
    dbms_output.put_line('Book 1 subject: ' || book1.subject);
    dbms_output.put_line('Book 1 book id: ' || book1.book_id);

    -- print book 2 record 
    dbms_output.put_line('Book 2 title: ' || book2.title);
    dbms_output.put_line('Book 2 author: ' || book2.author);
    dbms_output.put_line('Book 2 subject: ' || book2.subject);
    dbms_output.put_line('Book 2 book id: ' || book2.book_id);
END;
/

-- book records with procedure
DECLARE
TYPE books IS RECORD
(
    title VARCHAR2(50),
    author VARCHAR2(50),
    subject VARCHAR2(100),
    book_id NUMBER(2)
);
    book1 books;
    book2 books;
    PROCEDURE printbook (book books) IS
    BEGIN
        dbms_output.put_line('Book title: ' || book.title);
        dbms_output.put_line('Book author: ' || book.author);
        dbms_output.put_line('Book subject: ' || book.subject);
        dbms_output.put_line('Book book id: ' || book.book_id);
    END;
BEGIN
    -- book 1 records
    book1.title := 'JavaScript Programming';
    book1.author := 'John Mueich';
    book1.subject := 'Learn JavaScript Programming';
    book1.book_id := 12;

    -- book 2 records
    book2.title := 'SQL Queries';
    book2.author := 'Abim Jadhham';
    book2.subject := 'Study Oracle SQL';
    book2.book_id := 56;

    -- use procedure to print book info
    printbook(book1);
    printbook(book2);
END;
/

---------- CONSTANTS -------------

DECLARE
    -- constant declaration
    pi CONSTANT NUMBER := 3.141592654;
    -- other declarations
    radius NUMBER(5,2);
    dia NUMBER(5,2);
    circumference NUMBER(7,2);
    area NUMBER(10,2);
BEGIN
    -- processing
    radius := 9.5;
    dia := radius * 2;
    circumference := 2.0 * pi * radius;
    area := pi * radius * radius;
    -- output
    dbms_output.put_line('Radius: ' || radius);
    dbms_output.put_line('Diameter: ' || dia);
    dbms_output.put_line('Circumference: ' || circumference);
    dbms_output.put_line('Area: ' || area);
END;
/

--------------- CURSORS -------------------
DECLARE 
    total_rows NUMBER(10);
BEGIN
    UPDATE employees
    SET annual_salary = annual_salary + 500;
    IF sql%notfound THEN
        dbms_output.put_line('no employee selecter');
    ELSIF sql%found THEN
        total_rows := sql%rowcount;
        dbms_output.put_line( total_rows || ' employee selected ' );
    END IF;
END;
/
-- cursor syntax
-- CURSOR cursor_name IS select_statement;
--Объявление курсора определяет курсор с именем и соответствующим оператором SELECT. Например –
/* 
    CURSOR c_customers IS 
    SELECT id, name, address FROM customers;

    Объявление курсора определяет курсор с именем и соответствующим оператором SELECT. Например –
    CURSOR c_customers IS 
    SELECT id, name, address FROM customers; 

    Открытие курсора выделяет память для курсора и делает его готовым для извлечения в него строк, возвращаемых оператором SQL. Например, мы откроем определенный выше курсор следующим образом:

    OPEN c_customers;

    Выборка курсора вовлекает доступ к одной строке за один раз. Например, мы будем выбирать строки из открытого выше курсора следующим образом:
    FETCH c_customers INTO c_id, c_name, c_addr; 

    Закрытие курсора означает освобождение выделенной памяти. Например, мы закроем вышеуказанный курсор следующим образом:

    CLOSE c_customers;
*/      

DECLARE
    c_id customers.id%type;
    c_name customers.name%type;
    c_addr customers.adress%type;
    CURSOR c_customer IS
        SELECT id, name, adress FROM customers;
BEGIN
    OPEN c_customer;
    LOOP
    FETCH c_customer INTO c_id, c_name, c_addr;
        EXIT WHEN c_customer%notfound;
        dbms_output.put_line(c_id || ' ' || c_name || ' ' || c_addr);
    END LOOP;
    CLOSE c_customer;
END;
/
--------------- EXCEPTIONS --------------
DECLARE
    c_id customers.id%type := 8;
    c_name customers.name%type;
    c_addr customers.adress%type;
BEGIN
    SELECT name, adress INTO c_name, c_addr
    FROM customers
    WHERE id = c_id;
    dbms_output.put_line('Name: ' || c_name);
    dbms_output.put_line('Adress: ' || c_addr);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No such customer!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error!');
END;
/

-- programmer can use exception with RAISE command
/*
    DECLARE
        exception_name EXCEPTION;
    BEGIN
        IF condition THEN
            RAISE exception_name; 
        END IF;
    EXCEPTION
        WHEN exception_name THEN
        statement
    END;
*/

-- users exception

DECLARE
    c_id customers.id%type := 1;
    c_name customers.name%type;
    c_addr customers.adress%type;
    -- user defined exception
    ex_invalid_id EXCEPTION;
BEGIN
    IF c_id <= 0 THEN
        RAISE ex_invalid_id;
    ELSE
        SELECT name, adress INTO c_name, c_addr
        FROM customers
        WHERE id = c_id;
        dbms_output.put_line('Name: ' || c_name);
        dbms_output.put_line('Adress: ' || c_addr);
    END IF;
EXCEPTION
    WHEN ex_invalid_id THEN
        dbms_output.put_line('ID must be greater than zero!');
    WHEN no_data_found THEN
        dbms_output.put_line('No such customer!');
    WHEN OTHERS THEN
        dbms_output.put_line('Error!');
END;

--------------- TRIGGERS ---------------

CREATE OR REPLACE TRIGGER display_salary_changes
BEFORE DELETE OR INSERT OR UPDATE ON customers
FOR EACH ROW 
WHEN (NEW.ID > 0)
DECLARE
    sal_diff NUMBER;
BEGIN
    sal_diff := :NEW.salary - :OLD.salary;
    dbms_output.put_line('Old salary: ' || :OLD.salary);
    dbms_output.put_line('New salary: ' || :NEW.salary);
    dbms_output.put_line('Salary difference: ' || sal_diff);
END;
/

INSERT INTO CUSTOMERS (id, name, adress, salary)
VALUES (7, 'Kriti', 'HP', 7500);

UPDATE customers
SET salary = salary + 500
WHERE id = 2;

----------- JSON -----------------

CREATE TABLE j_purchase
(
    id VARCHAR2 (32) NOT NULL PRIMARY KEY,
    date_loaded TIMESTAMP (6) WITH TIME ZONE,
    po_document VARCHAR2(3276)
    CONSTRAINT ensuring_json CHECK (po_document IS JSON)
);

INSERT INTO j_purchase
    VALUES (
        SYS_GUID(),
        to_date('23/04/49', 'DD/MM/YY'),
        '{
            "Ponumber"             : 1600,
            "Reference"            : "ABULL-20140421",
            "Requestor"            : "Alexis Bull",
            "User"                 : "ABULL",
            "CostCenter"           : "A50",
            "Special Instructions" : null,
            "AllowPartialShipment" : true
        }'
    );
SELECT po.po_document.Ponumber FROM j_purchase po;
SELECT po.po_document.ShippingInstructions.Phone FROM j_purchase po;

---------------- XML ORACLE-----------------

-- XMLELEMENT

SELECT e.id, XMLELEMENT("Sal", e.annual_salary) AS "Employee Salary", XMLELEMENT ("Emp", e.full_name) AS "result"
   FROM employees e
   WHERE id > 200;

-- XML STRUCTURE

SELECT XMLELEMENT("Emp", XMLELEMENT("name", e.full_name),
                           XMLELEMENT ( "hiredate", e.hire_date)) AS "result" 
FROM employees e 
WHERE id > 200 ;

--------- TODO APEX PROJECT ----------------
-- створення таблиці
CREATE TABLE "TODO"
(
    "PID" NUMBER,
    "TODO" VARCHAR2(50) NOT NULL ENABLE,
    "INSERT_BY" VARCHAR2(100),
    "UPDATE_BY" VARCHAR2(100), 
    "UPDATE_DATE" TIMESTAMP(6),
    "INSERT_DATE" TIMESTAMP(6),
    CONSTRAINT "TODO_PK" PRIMARY KEY ("PID")
);

-- створення тригеру

CREATE OR REPLACE TRIGGER "TODO_PK"
    BEFORE INSERT OR UPDATE
    on TODO
    for each row
    BEGIN
    -- если идет ввод нового задания
        if inserting then
        -- срабатывает триггер если айди пустой то выбирает максимальный из существующих и добавляет +1 к нему
            if :NEW.PID is null then
                SELECT nvl(max(pid),0) + 1
                into :NEW.PID
                FROM TODO;
            end if;
            -- вводит текущую дату и имя юзера
            :NEW.INSERT_DATE := localtimestamp;
            :NEW.INSERT_BY := nvl(v('APP_USER'), USER);
        end if;

        -- если идет обновление уже созданного задания
        if updating then
            :NEW.UPDATE_DATE := localtimestamp;
            :NEW.UPDATE_BY := nvl(v('APP_USER'), USER);
        end if;
    END;

