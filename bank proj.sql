CREATE DATABASE bank_loan_data;
DROP database bank_loan_data;
DROP table financial_loan;
CREATE TABLE financial_loan_test (
    id VARCHAR(50),
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(100),
    grade VARCHAR(50),
    home_ownership VARCHAR(50),
    issue_date VARCHAR(50),
    last_credit_pull_date VARCHAR(50),
    last_payment_date VARCHAR(50),
    loan_status VARCHAR(50),
    next_payment_date VARCHAR(50),
    member_id VARCHAR(50),
    purpose VARCHAR(50),
    sub_grade VARCHAR(50),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount FLOAT,
    total_acc INT,
    total_payment FLOAT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financial_loan.csv'
INTO TABLE financial_loan_test
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

CREATE TABLE financial_loan (
    id VARCHAR(50),
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(100),
    grade VARCHAR(50),
    home_ownership VARCHAR(50),
    issue_date DATE,
    last_credit_pull_date VARCHAR(50),
    last_payment_date VARCHAR(50),
    loan_status VARCHAR(50),
    next_payment_date VARCHAR(50),
    member_id VARCHAR(50),
    purpose VARCHAR(50),
    sub_grade VARCHAR(50),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount FLOAT,
    total_acc INT,
    total_payment FLOAT
);
INSERT INTO financial_loan (id, address_state, application_type, emp_length,emp_title,grade,home_ownership,issue_date,
last_credit_pull_date,last_payment_date,loan_status,next_payment_date,member_id,purpose,sub_grade,term,verification_status,
annual_income,dti,installment,int_rate,loan_amount,total_acc,total_payment)
SELECT 
  id, address_state, application_type, emp_length,emp_title,grade,home_ownership,STR_TO_DATE(issue_date, '%d-%m-%Y')
,
last_credit_pull_date,last_payment_date,loan_status,next_payment_date,member_id,purpose,sub_grade,term,verification_status,
annual_income,dti,installment,int_rate,loan_amount,total_acc,total_payment 
FROM financial_loan_test;

SELECT 
  id,
  member_id,
  loan_amount,
  STR_TO_DATE(issue_date, '%d-%m-%Y')
FROM financial_loan;


SELECT * FROM financial_loan;


-- KEY PERFORMANCE INDICATORS KPI --
-- 1. TO FIND OUT THE TOTAL LOAN APPLICATIONS --
SELECT COUNT(id) AS total_loan_applications
FROM financial_loan;

--  MONTH TO DATE FROM THE LATEST YEAR  --
SELECT COUNT(id) AS MTD_total_loan_applications 
FROM financial_loan
WHERE MONTH(STR_TO_DATE(issue_date, '%d-%m-%Y')) = 12 AND YEAR(STR_TO_DATE(issue_date, '%d-%m-%Y')) = 2021;

--  MONTH TO MONTH  FROM THE PREVIOUS MONTH --
SELECT COUNT(id) AS PMTD_total_loan_applications 
FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- TO FIND OUT FOR THE CURRENT MONTH IS --
-- (MTD-PMTD/PMTD --

-- 2. TOTAL FUNDED AMOUNT --

SELECT SUM(loan_amount) AS total_funded_amount FROM financial_loan;

-- MONTH TO DATE --
SELECT SUM(loan_amount) AS PMTD_total_funded_amount FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT SUM(loan_amount) AS total_funded_amount FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 3. TOTAL AMOUNT RECEIVED --

SELECT SUM(total_payment) AS MTD_total_amount_received FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;


SELECT SUM(total_payment) AS PMTD_total_amount_received FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


-- 4. AVERAGE INT RATE -P-

SELECT AVG(int_rate) * 100 AS average_int_rate
FROM financial_loan;

-- IF U WANT ANY DECIMAL POINTS LIKE 1 OR 2 THEN U CAN USE ROUND FUNCTION -- 

SELECT ROUND(AVG(int_rate), 4) * 100 AS average_int_rate
FROM financial_loan;

SELECT ROUND(AVG(int_rate), 4) * 100 AS MTD_average_int_rate
FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(int_rate), 4) * 100 AS PMTD_average_int_rate
FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


-- 5. AVERAGE DEBT INCOME RATIO --
SELECT ROUND(AVG(dti),4) * 100  AS avg_dti FROM financial_loan;

SELECT ROUND(AVG(dti),4) * 100  AS MTD_avg_dti FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT ROUND(AVG(dti),4) * 100  AS PMDT_avg_dti FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;


-- 2. GOOD LOAN AND BAD LOAN --
SELECT loan_status FROM financial_loan;

-- 2.1GOOD LOAN APPLICATION PERCENTAGE --
SELECT 
	ROUND(
	(COUNT(CASE WHEN loan_status = 'fully paid' OR loan_status = 'current' THEN id END) * 100.0)
    /COUNT(id),
    0
    )AS good_loan_percentage	
    FROM financial_loan;
    

-- 2.1 GOOD LOAN APPLICATIONS --

SELECT COUNT(id) AS good_loan_application FROM financial_loan
WHERE loan_status = 'fully paid' OR loan_status = 'current';

-- 2.2 GOOD LOAN FUNDED AMOUNT --

 SELECT SUM(loan_amount) AS good_loan_funded_amount FROM financial_loan
WHERE loan_status = 'fully paid' OR loan_status = 'current';

-- 2.3 GOOD LOAN TOTAL RECEIVED AMOUNT --

SELECT SUM(total_payment) AS good_loan_received_amount FROM financial_loan
WHERE loan_status = 'fully paid' OR loan_status = 'current';

-- 2.3 BAD LOAN PERCENTAGE --

SELECT 
	ROUND(
    (COUNT(CASE WHEN loan_status = 'charged off'  THEN id END) * 100.0)
    /COUNT(id),
    0
    )AS bad_loan_percentage	
    FROM financial_loan;

-- 2.3 TOTAL APPLICATIONS OF BAD LOAN --

SELECT COUNT(id) AS bad_loan_application FROM financial_loan
WHERE loan_status = 'charged off';


-- 2.4 BAD LOAN FUNDED AMOUNT --

SELECT SUM(loan_amount) AS bad_loan_funded_amount FROM financial_loan
WHERE loan_status =  'charged off';

-- 2.5 bad loan amount received --

SELECT SUM(total_payment) AS bad_loan_amount_received FROM financial_loan
WHERE loan_status =  'charged off';


-- 3. LOAN STATUS GRID VIEW --

SELECT 
	loan_status,
    COUNT(id) AS total_loan_applications,
    SUM(total_payment) AS total_amount_received,
    SUM(loan_amount) AS total_funded_amount,
    AVG(int_rate * 100) AS interest_rate,
    AVG(dti * 100) AS DTI
    FROM 
    financial_loan
    GROUP BY loan_status;


-- 3.1 month to date and preivous month to date --

SELECT 
	loan_status,
    SUM(total_payment) AS MTD_total_amount_received,
    SUM(loan_amount) AS MTD_total_funded_amount
    FROM financial_loan
    WHERE MONTH(issue_date) = 12
    GROUP BY loan_status;
    
    
-- 4.1 MONTHLY TRENDS  BY ISSUE DATE -- 

SELECT 
    Month_Name,
    Total_Loan_Applications,
    Total_Funded_Amount,
    Total_Received_Amount
FROM (
    SELECT 
        MONTHNAME(issue_date) AS Month_Name,
        MONTH(issue_date) AS Month_Number,
        COUNT(id) AS Total_Loan_Applications,
        SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Received_Amount
    FROM financial_loan
    GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
) AS monthly_data
ORDER BY month_name ;

SELECT 
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);

-- 4.2 REGIONAL ANALYSIS BY STATE --
SELECT 
	address_state,
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY address_state
ORDER BY SUM(loan_amount) DESC;

-- 4.3 LOAN TERM ANALYSIS --
SELECT term,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_Amount,
	SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY term
ORDER BY term;


-- 4.4 EMPLOYEE LENGTH ANALYSIS --
SELECT * FROM financial_loan;

SELECT emp_length,
	COUNT(id) AS total_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length;

-- if u wanna see for which employee the total applicatiosn are given --
SELECT emp_length,
	COUNT(id) AS total_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY emp_length
ORDER BY COUNT(id) DESC;

-- 4.5 LOAN PURPOSE BREAK DOWN --
SELECT purpose,
	COUNT(id) AS total_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY purpose
ORDER BY COUNT(id) DESC;

-- 4.6 HOME OWNDERSHIP ANALYSIS -- 

SELECT * FROM financial_loan;

SELECT home_ownership,
	COUNT(id) AS total_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_received_amount
FROM financial_loan
GROUP BY home_ownership
ORDER BY COUNT(id) DESC; 

SELECT @@hostname, CURRENT_USER();
