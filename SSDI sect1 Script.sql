-- Get the total beneficiaries each year 
SELECT "Year", CAST(REPLACE(Total, ',', '') AS INTEGER) AS TotalInt
FROM sect01b sb;

-- Order total beneficiaries per year in descending order of magnitude
SELECT "Year", CAST(REPLACE(Total, ',', '') AS INTEGER) AS TotalInt
FROM sect01b
ORDER BY TotalInt DESC;


-- Find the average monthly benefits for each demographic between 2011 and 2021
SELECT "Year", "Avg Mon for Workers ($)", "Avg Mon for Widow(er)s ($)", "Avg Mon for Adult children ($)"
FROM sect01b sb 
WHERE "Year" BETWEEN 2011 AND 2021;

-- Find the years where the total benefits decreased from the previous year
WITH Total_Changes AS (
  SELECT "Year",
         CAST(REPLACE("Total Mon for Workers (x$1000)", ',', '') AS INTEGER) AS "Total Mon for Workers (x$1000)",
         LAG(CAST(REPLACE("Total Mon for Workers (x$1000)", ',', '') AS INTEGER), 1) OVER previous AS "prev_Total Mon for Workers (x$1000)",
		 CAST(REPLACE("Total Mon for Widow(er)s (x$1000)", ',', '') AS INTEGER) AS "Total Mon for Widow(er)s (x$1000)",
         LAG(CAST(REPLACE("Total Mon for Widow(er)s (x$1000)", ',', '') AS INTEGER), 1) OVER previous AS "prev_Total Mon for Widow(er)s (x$1000)",
         CAST(REPLACE("Total Mon for Adult children (x$1000)", ',', '') AS INTEGER) AS "Total Mon for Adult children (x$1000)",
         LAG(CAST(REPLACE("Total Mon for Adult children (x$1000)", ',', '') AS INTEGER), 1) OVER previous AS "prev_Total Mon for Adult children (x$1000)"
  FROM sect01b sb 
  WINDOW previous AS (ORDER BY "Year")
)
SELECT *
FROM Total_Changes
WHERE "Total Mon for Workers (x$1000)" < "prev_Total Mon for Workers (x$1000)"
   OR "Total Mon for Widow(er)s (x$1000)" < "prev_Total Mon for Widow(er)s (x$1000)"
   OR "Total Mon for Adult children (x$1000)" < "prev_Total Mon for Adult children (x$1000)"
   OR "prev_Total Mon for Workers (x$1000)" IS NULL
   OR "prev_Total Mon for Widow(er)s (x$1000)" IS NULL
   OR "prev_Total Mon for Adult children (x$1000)" IS NULL
ORDER BY "Year";

-- Find the difference by which the total benefits decreased from the previous year
-- Created table from previous query results for efficiency
WITH Prev_Difference AS (
  SELECT CAST(REPLACE("Year", ',', '') AS TEXT) AS "Year", 
  	 	 ("Total Mon for Workers (x$1000)" - "prev_Total Mon for Workers (x$1000)") AS "Workers Difference",
		 ("Total Mon for Widow(er)s (x$1000)" - "prev_Total Mon for Widow(er)s (x$1000)") AS "Widow(er)s Difference",
		 ("Total Mon for Adult children (x$1000)" - "prev_Total Mon for Adult children (x$1000)") AS "Adult Children Difference"
  FROM TotalMonthlyBenefits 
  ORDER BY "Year"
)
SELECT * 
FROM Prev_Difference;


