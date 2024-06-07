select *from financial_loan

--Total loan applications
select count (id) as Total_Applications
from financial_loan

--Total of PMTD loan app

select count (id) as PMTD_Total_Applications
from financial_loan
where month (issue_date)= 11 and year(issue_date) = 2021

--Total Funded Amount:
--MTD
select sum (loan_amount)  AS MTD_Tolal_Funded_Amount
from financial_loan 
where month(issue_date) = 12 and year(issue_date)= 2021

--PMDT
select sum (loan_amount)  AS PMTD_Tolal_Funded_Amount
from financial_loan 
where month(issue_date) = 11 and year(issue_date)= 2021

--MoM RATE

-- Step 1: Use a CTE to calculate MTD and PMTD totals
WITH MTD_and_PMTD AS (
    SELECT
        SUM(CASE WHEN month(issue_date) = 12 AND year(issue_date) = 2021 THEN loan_amount ELSE 0 END) AS MTD_Total_Funded_Amount,
        SUM(CASE WHEN month(issue_date) = 11 AND year(issue_date) = 2021 THEN loan_amount ELSE 0 END) AS PMTD_Total_Funded_Amount
    FROM
        financial_loan
)

-- Step 2: Calculate the MoM rate
SELECT
    MTD_Total_Funded_Amount,
    PMTD_Total_Funded_Amount,
    ROUND(
        (MTD_Total_Funded_Amount - PMTD_Total_Funded_Amount) / NULLIF(PMTD_Total_Funded_Amount, 0) * 100, 
        2
    ) AS MoM_Rate
FROM
    MTD_and_PMTD;

-- Total Amount Received 
select *from financial_loan

select sum(total_payment) As Total_Amount_Received
from financial_loan

--MoM Rate

--Using a CTE to calculate MTD and PMTD totals

WITH MTD_and_FMTD AS (
    SELECT
        SUM(CASE WHEN month(issue_date) = 12 AND year(issue_date) = 2021 THEN total_payment ELSE 0 END) AS MTD_Total_Amount_Received,
        SUM(CASE WHEN month(issue_date) = 11 AND year(issue_date) = 2021 THEN total_payment ELSE 0 END) AS PMTD_Total_Amount_Received
    FROM
        financial_loan
)
SELECT 
    MTD_Total_Amount_Received,
    PMTD_Total_Amount_Received,
    ROUND(
        (MTD_Total_Amount_Received - PMTD_Total_Amount_Received) / NULLIF(PMTD_Total_Amount_Received, 0) * 100, 
        2
    ) AS MoM_Rate
FROM
    MTD_and_FMTD;

--Average Interest Rate 
select *from financial_loan

select round(avg (int_rate),2) AS Average_Interest_Rate
from financial_loan

--Average Dept to Income Ration(DTI)
SELECT ROUND (AVG (dti)*100,2 )  AS Average_DTI
FROM financial_loan 

--MoM Rate

WITH MoM_table AS (
SELECT 
	AVG (CASE WHEN MONTH(date_issue) = 12 AND YEAR(date_issue) = 2021 THEN dti ELSE 0 END) AS MTD_Average_DTI,
	AVG (CASE WHEN MONTH(date_issue) = 11 AND YEAR(date_issue) = 2021 THEN dti ELSE 0 END) AS PMTD_Average_DTI

FROM financial_loan 
	)

SELECT
	MTD_Average_DTI, PMTD_Average_DTI,
	ROUND(MTD_Average_DTI - PMTD_Average_DTI / NULLIF (PMTD_Average_DTI,0) *100,2) AS MoM_Rate

FROM MoM_table

	
select *from financial_loan

--Good Loan vs Bad Loan KPI's

--Good Loan:
--1.Good Loan Applications Percentage   
select
(count(case when loan_status = 'Fully Paid' or loan_status= 'Current' then id END)* 100)/count(id) AS Good_Loan_Applications_Percentage
from financial_loan 

--2.Good Loan Applications
select *from financial_loan

SELECT COUNT (ID) AS Count_Of_Good_Loan_Applications
FROM financial_loan
WHERE loan_status= 'Fully Paid' OR loan_status= 'Current'

--3.Good Loan Funded Amount 
select *from financial_loan

SELECT SUM (loan_amount) AS GoodLoanFundedAmount 
FROM financial_loan
WHERE loan_status= 'Fully Paid' OR loan_status= 'Current'

--4 Good Loan Total Received Amount
select *from financial_loan

SELECT SUM (total_payment) AS GoodLoanTotalReceivedAmount 
FROM financial_loan
WHERE loan_status= 'Fully Paid' OR loan_status= 'Current'

--Bad Loan
--1.Bad Loan Applications Percentage    
select *from financial_loan

select
CAST(ROUND((count(case when loan_status = 'Charged Off' then id END)* 100.)/count(id),2) as decimal(5,2))AS Bad_Loan_Applications_Percentage
from financial_loan 

--2.Bad Loan Applications

select *from financial_loan

SELECT COUNT (id) AS Count_Of_Bad_Loan_Applications
FROM financial_loan
WHERE loan_status= 'Charged Off'

 --3.Bad Loan Funded Amount

 select *from financial_loan

SELECT SUM (loan_amount) AS BadLoanFundedAmount 
FROM financial_loan
WHERE loan_status= 'Charged Off'

 --4 Bad Loan Total Received Amount

 select *from financial_loan

SELECT SUM (total_payment) AS BadLoanTotalReceivedAmount 
FROM financial_loan
WHERE loan_status= 'Charged Off'

--Loan Status Grid View
SELECT 
loan_status,
COUNT(id) as LoanCount,
SUM (loan_amount) AS Total_Funded_Amount,
SUM (total_payment) AS Total_Funded_Amount_Received,
ROUND(AVG(int_rate* 100),2) AS Average_Interest,
round(AVG(dti)*100,2) AS DTI
FROM financial_loan
GROUP BY loan_status

--Monthly Trends by Issue Date
select *from financial_loan

SELECT 
       MONTH (issue_date) AS Month_Number, 
       DATENAME (MONTH,issue_date) AS Issue_Date,
       count(id) AS Total_Applications, sum (loan_amount) AS Total_Funded_Amount, sum(total_payment) AS total_payment
FROM financial_loan
GROUP BY MONTH (issue_date), DATENAME (MONTH,issue_date) 
ORDER BY MONTH (issue_date), DATENAME (MONTH,issue_date)


--Monthly Trends by Address
SELECT address_state,
count(id) AS Total_Applications, sum (loan_amount) AS Total_Funded_Amount, sum(total_payment) AS total_payment
FROM financial_loan
GROUP BY address_state
ORDER BY Total_Applications DESC

select *from financial_loan

--Loan Term Analysis
SELECT term, count(id) AS Total_Applications, sum (loan_amount) AS Total_Funded_Amount, sum(total_payment) AS total_payment
from financial_loan
GROUP BY term
ORDER BY term DESC

--Employee Length Analysis 

SELECT emp_length,
       count(id) AS Total_Applications, sum (loan_amount) AS Total_Funded_Amount, sum(total_payment) AS total_payment
from financial_loan
GROUP BY emp_length
ORDER BY Total_Applications DESC

--Loan Purpose Breakdown 
select *from financial_loan

SELECT purpose,
       count(id) AS Total_Applications, sum (loan_amount) AS Total_Funded_Amount, sum(total_payment) AS total_payment
from financial_loan
GROUP BY purpose
ORDER BY Total_Applications DESC

--Home Ownership Analysis 

SELECT home_ownership,
       count(id) AS Total_Applications, sum (loan_amount) AS Total_Funded_Amount, sum(total_payment) AS total_payment
from financial_loan
WHERE grade = 'A' AND address_state= 'CA'
GROUP BY home_ownership
ORDER BY Total_Applications DESC

