DROP DATABASE IF EXISTS credit_risk_project;
SHOW DATABASES;
CREATE DATABASE IF NOT EXISTS credit_risk_project;

USE credit_risk_project;
DROP TABLE IF EXISTS credit_bureau;
DROP TABLE IF EXISTS Loans;
CREATE TABLE Customer (
    person_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    person_age INT NOT NULL,
    person_income DECIMAL(12,2) NULL,
    person_home_ownership VARCHAR(255) NOT NULL,
    person_emp_length SMALLINT NULL      -- allow NULLs
);
CREATE TABLE Loans (
    loan_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT UNSIGNED NOT NULL,  -- must match UNSIGNED
    loan_amnt DECIMAL(12,2) NOT NULL,
	loan_int_rate FLOAT(53) NULL,
									-- allow NULLs and decimals
    loan_intent VARCHAR(255) NOT NULL,
    loan_grade VARCHAR(255) NOT NULL,
    loan_status VARCHAR(255) NOT NULL,
    loan_percent_income DECIMAL(8,4) NOT NULL,
    CONSTRAINT loans_person_id_fk FOREIGN KEY (person_id) REFERENCES Customer(person_id)
);
CREATE TABLE credit_bureau (
    cb_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT UNSIGNED NOT NULL,
    cb_person_default_on_file VARCHAR(255) NOT NULL,
    cb_person_cred_hist_length INT NOT NULL,
    CONSTRAINT credit_bureau_person_id_fk FOREIGN KEY (person_id) REFERENCES Customer(person_id)
);
SELECT COUNT(*) AS customer_rows FROM Customer;
SELECT COUNT(*) AS loan_rows FROM Loans;
SELECT COUNT(*) AS credit_bureau_rows FROM credit_bureau;
SELECT COUNT(*) AS null_person_id_in_loans 
FROM Loans
WHERE person_id IS NULL;
SELECT COUNT(*) AS missing_emp_length
FROM Customer
WHERE person_emp_length IS NULL;
SELECT MIN(person_age) AS min_age, MAX(person_age) AS max_age FROM Customer;

SELECT COUNT(*) AS invalid_person_ids_in_loans
FROM Loans l
LEFT JOIN Customer c ON l.person_id = c.person_id
WHERE c.person_id IS NULL;
SELECT 
    SUM(loan_amnt IS NULL) AS null_loan_amnt,
    SUM(loan_int_rate IS NULL) AS null_loan_int_rate,
    SUM(loan_status IS NULL) AS null_loan_status
FROM Loans;
SELECT DISTINCT loan_int_rate
FROM Loans
ORDER BY loan_int_rate;