/*Create a database named employee, then import data_science_team.csv, proj_table.csv and emp_record_table.csv
into the employee database from the given resources*/

CREATE DATABASE EMPLOYEE;
SELECT* FROM EMPLOYEE.data_science_team;
SELECT* FROM EMPLOYEE.emp_record_table;
SELECT* FROM EMPLOYEE.proj_table;

/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
and make a list of employees and details of their department*/

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT FROM EMPLOYEE.emp_record_table;

/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the 
EMP_RATING is: (a) less than two (b) greater than four (c) between two and four*/

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM EMPLOYEE.emp_record_table WHERE EMP_RATING<'2';

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM EMPLOYEE.emp_record_table WHERE EMP_RATING>'4';

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM EMPLOYEE.emp_record_table 
WHERE EMP_RATING BETWEEN '2' AND '4';

/*Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in theFinancedepartment from the 
employee table and then give the resultant column alias as NAME.*/

SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS NAME FROM EMPLOYEE.emp_record_table WHERE DEPT='FINANCE';

/*Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters 
(including the President).*/

SELECT EMP_ID,FIRST_NAME,LAST_NAME,ROLE FROM EMPLOYEE.emp_record_table WHERE ROLE='MANAGER' OR ROLE='PRESIDENT';

/*Write a query to list down all the employees from the healthcare and finance departments using union. 
Take data from the employee record table.*/

SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM EMPLOYEE.emp_record_table WHERE DEPT='HEALTHCARE' UNION
SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM EMPLOYEE.emp_record_table WHERE DEPT='FINANCE' ORDER BY EMP_ID;

/*Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, 
and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the 
department.*/

SELECT EMP_ID,FIRST_NAME, LAST_NAME, ROLE, DEPT,EMP_RATING, MAX(EMP_RATING) 
OVER(PARTITION BY DEPT) AS MAX_EMP_RATING FROM EMPLOYEE.emp_record_table ORDER BY DEPT;

/*Write a query to calculate the minimum and the maximum salary of the employees in each role. 
Take data from the employee record table.*/

SELECT EMP_ID,FIRST_NAME, LAST_NAME, ROLE, SALARY, MAX(SALARY) 
OVER(PARTITION BY ROLE) AS MAX_SALARY, MIN(SALARY) 
OVER(PARTITION BY ROLE) AS MIN_SALARY FROM EMPLOYEE.emp_record_table;

/*Write a query to assign ranks to each employee based on their experience. 
Take data from the employee record table.*/

SELECT EMP_ID,FIRST_NAME, LAST_NAME, EXP,
RANK() OVER(ORDER BY EXP) EMP_RANK FROM EMPLOYEE.emp_record_table;

/*Write a query to create a view that displays employees in various countries whose salary is more than 
six thousand.Take data from the employee record table.*/

CREATE VIEW EMPLOYEE.EMP_TABLE AS SELECT EMP_ID,FIRST_NAME, LAST_NAME, COUNTRY,SALARY 
FROM EMPLOYEE.emp_record_table WHERE SALARY>'6000';

/*Write a nested query to find employees with experience of more than ten years. 
Take data from the employee record table.*/

SELECT* FROM EMPLOYEE.EMP_TABLE;

SELECT* FROM EMPLOYEE.emp_record_table WHERE EXP>'10';

SELECT* FROM EMPLOYEE.emp_record_table WHERE EXP IN (SELECT EXP FROM EMPLOYEE.emp_record_table WHERE EXP>'10');

/*Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than 
three years. Take data from the employee record table.*/

DELIMITER &&
CREATE PROCEDURE EMPLOYEE.EXP_MORE_THAN_3()
BEGIN
SELECT* FROM EMPLOYEE.emp_record_table WHERE EXP>'3' ORDER BY EXP;
END &&
CALL EMPLOYEE.EXP_MORE_THAN_3();

/*Write a query using stored functions in the project table to check whether the job profile assigned to each 
employee in the data science team matches the organization’s set standard. 
The standard is given as follows:
• Employee with experience less than or equal to 2 years, assign 'JUNIOR DATA SCIENTIST’
• Employee with experience of 2 to 5 years, assign 'ASSOCIATE DATA SCIENTIST’
• Employee with experience of 5 to 10 years, assign 'SENIOR DATA SCIENTIST’
• Employee with experience of 10 to 12 years, assign 'LEAD DATA SCIENTIST’,
• Employee with experience of 12 to 16 years, assign 'MANAGER'*/

DELIMITER &&
CREATE PROCEDURE EMPLOYEE.ORG_STAND (
IN EID VARCHAR(4), OUT JOB_PROFILE VARCHAR(50))
BEGIN
    DECLARE EXPERIENCE INT;
    SELECT EXP INTO EXPERIENCE FROM EMPLOYEE.emp_record_table WHERE EMP_ID=EID;
    IF EXPERIENCE<='2' THEN
        SET JOB_PROFILE ='JUNIOR DATA SCIENTISTS';
	ELSEIF EXPERIENCE BETWEEN '2' AND '5' THEN
        SET JOB_PROFILE ='ASSOCIATE DATA SCIENTISTS';
	ELSEIF EXPERIENCE BETWEEN '5' AND '10' THEN
        SET JOB_PROFILE ='SENIOR DATA SCIENTISTS';
	ELSEIF EXPERIENCE BETWEEN '10' AND '12' THEN
        SET JOB_PROFILE ='LEAD DATA SCIENTISTS';
	ELSEIF EXPERIENCE BETWEEN '12' AND '16' THEN
        SET JOB_PROFILE ='MANAGER';
	ELSE
        SET JOB_PROFILE ='WRONG PROFILE';
	END IF;
END &&	
CALL EMPLOYEE.ORG_STAND('E005',@JOB_PROFILE);
SELECT @JOB_PROFILE;

/*Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ 
in the employee table after checking the execution plan.*/

CREATE INDEX idx_name ON EMPLOYEE.emp_record_table(FIRST_NAME(20));
explain SELECT* FROM EMPLOYEE.emp_record_table WHERE FIRST_NAME='Eric';

/*Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
(Use the formula: 5% of salary * employee rating).*/

SELECT EMP_ID, FIRST_NAME, LAST_NAME, EMP_RATING,SALARY, 
(0.05*SALARY*EMP_RATING) AS BONUS FROM EMPLOYEE.emp_record_table ORDER BY EMP_RATING;

/*Write a query to calculate the average salary distribution based on the continent and country. 
Take data from the employee record table.*/

SELECT EMP_ID,FIRST_NAME,LAST_NAME,CONTINENT,COUNTRY, SALARY, AVG(SALARY) OVER(PARTITION BY COUNTRY) 
AS AVERAGE_SALARY_COUNTRY ,AVG(SALARY) OVER(PARTITION BY CONTINENT) AS AVERAGE_SALARY_CONTINENT 
FROM EMPLOYEE.emp_record_table;