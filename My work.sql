SELECT first_name, last_name,"old man" As label
	FROM employee_demographics 
    where age > 40 And gender = "Male"
-- this code gets the name of the male employees who are older than 40 years and give
-- label old man 
UNION 
SELECT first_name, last_name , "old lady" AS label
	FROM employee_demographics
    where age > 40 and gender = "Female"
-- do the same as the fist select but here for womens 
union
SELECT first_name , last_name , "highly paid employee"
	FROM employee_salary
    where salary > 70000 
-- get thr highily paid employees
ORDER BY first_name, last_name ;

-- String Functions
 Select length("Abdo");
/* it used when u deal with phon numbers and wants 
to make sure that the number is 11 number*/

-- UPPER --> it makes all the characters capital 
-- LOWER --> it make all the characters Samall
-- TRIM -->  it removes all the speaces from the statement except the ones betweeen the words 
-- 	left TRIM --> removes spaces from left 
-- Right TRIM --> removes spaces from right
-- LEFT (name,4) --> it returns only the first four Characters from left
-- RIGHT (name, 4)--> it reuns the first four characters from right
-- SUBSTRING ( name,3,2)--> i means that it will start from the 3 position in the word and return 2 characters only 
-- it useful with extracting months from date for example 
-- replace(coulmn name , "old value", "new value")--> replace the old value with new values
-- locate ("what you looking for","the word you look at") --> it tells you the position of the charaacter in a word for example
-- concat ( "value 1", " ", "value 2") --> it combite the two values  it use for the combining the first and lst name


select birth_date,substring(birth_date,6,2) as birth_month
	from employee_demographics;

select first_name,replace(first_name,"a","W") 
	from employee_demographics;
    
select locate('o', "Abdo");

select first_name,last_name, concat(first_name," ",last_name) 
	from employee_demographics;

	
select first_name,
	last_name,
    age,
Case
	when age <= 30 then "Young"
    when age between 31 and 50 then "old"
    when age >= 50 then "on death door"
end as label 
from employee_demographics;

/* look at the following info.
pay increase and bouns 
if they made less than or equal to 50000 it gives them 5% bonus 
if they made great than 50000 it gives them 7% bonus 
if they work in the Finance department give them 10% bonus
*/

select first_name,
	   last_name,
       salary,
	Case
    when salary > 50000 then salary + (salary*0.07)
    when salary <= 50000 then salary + (salary*0.05)
    end as new_salary,
    case 
    when dept_id = 6 then salary*0.1
    end as Extra_Finance_Bouns 
		from employee_salary; 


 -- the folowing code give you more accurate results because it it give the finance department works only 10%        
        
SELECT 
  first_name,
  last_name,
  salary,
  CASE 
    WHEN (select department_name
			from parks_departments pd
            inner join employee_salary es
            on pd.department_id = es.dept_id
            where pd.department_name = "Finance"
    ) = "finance" THEN salary * 1.10  -- Finance gets only 10%
    WHEN salary > 50000 THEN salary + (salary * 0.07)
    WHEN salary <= 50000 THEN salary + (salary * 0.05)
  END AS new_salary
FROM employee_salary;


-- Subqueries 

/* if you used aggregate functions in the subquery you should use alias for the subquery
    so, you can put the alias in other aggregate functions and if you didn't do this you
    should use `` its called backticks for example like this Avg(`MAX(salary)`) */


-- Window Functions 


-- CTEs -->Common Table Expressions 

WITH cte_example (Emp_ID, First_Name, Last_Name, Gender, Age) AS (
    SELECT employee_id, first_name, last_name, gender, age
    FROM employee_demographics
    WHERE age > 30
),
cte_example2  (Emp_ID, Salary )AS (
    SELECT employee_id, salary
    FROM employee_salary
    WHERE salary > 50000
    )
SELECT p.Emp_ID,first_name,last_name, salary
FROM cte_example  p
inner join cte_example2 s
    ON p.Emp_ID = s.Emp_ID;


-- Temporery Tables 
/* it's table that is temporery which you can only use it on the same sessions 
    u can use in the samw sessions on more than one page 
    if u exist or ended your sessions y will not be able to use it again
*/

CREATE TEMPORARY TABLE salary_over_60K
SELECT * 
FROM employee_salary
WHERE salary >= 60000;

SELECT *
FROM salary_over_60K;
-- this query make a temporary table that contains all the employees who have salary greater than or equal to 60000


-- Stored Procedures 

CREATE PROCEDURE large_salary()
SELECT * 
from employee_salary
where salary >= 50000;
-- here we made the stored procedure successfuly 
-- to use this stored procedure we use CALL

CALL large_salary();
-- this was a very simole stored procedure 

/*
Now let's move to more complex procedures 
1- we use delimiter to identifiy where the query stops  the defult is ;
2- we can use $$ or // as a delimiter 
3- we change delimiter to $$ or // first when we try to make a procedure 
that contain more than one query because if we didn't do this he will take 
the first query as a procedure and will show the the remained queries as result
4-don't forget to reset the delimiter to the defult vaule which is ;

*/

DELIMITER $$ -- change the delimiter to $$ 
CREATE PROCEDURE large_salary2()
BEGIN
	SELECT *
    FROM employee_salary
    where salary >= 50000;
    SELECT *
    FROM employee_salary
    WHERE salary >= 10000;
END$$ 
DELIMITER ; 

-- paramater 

DELIMITER $$
CREATE PROCEDURE large_salaries4(jjjj INT)
BEGIN
	SELECT salary
    FROM employee_salary
    Where employee_id = jjjj
    ;
END $$
DELIMITER ;

CALL large_salaries4(1)



-- Triggers --> it is a block of code that executes automaticly when events takes place on specific table 

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN 
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VAlUES (NEW.employee_id, NEW.first_name, NEW.last_name  );
END $$
DELIMITER ;

INSERT INTO employee_salary
VALUES (13, "Abdo", "Shahin","External Auditor & Financial Analyst",150000,NULL);

select * 
from employee_demographics; -- when u check u find that the trigger works 

select * 
from employee_salary; 


-- Events --> it heppens when it is schudeled 
/*it helps and it good for automation, for example when u what to do something based on time like what everyday 
to exteract the top 10 selling products for eaxmple.
*/

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN
	DELETE 
    FROM employee_demographics 
    WHERE age >= 60;
END$$
DELIMITER ;

SHOW VARIABLES LIKE "event%"; -- to see if the event is on or off 