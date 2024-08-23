--Dataset at a glance
SELECT *
   FROM portfolioproject..Shopping_Trends_23_Copy

--A look at MIN, MAX and AVG of the age group
SELECT MIN(Age)AS MinAge,MAX(Age) AS MaxAge, AVG(Age) AS AverageAge
   FROM portfolioproject..Shopping_Trends_23_Copy

--Reviews Average For Both Sex
SELECT Gender, AVG(Review_Rating) AS ReviewAverage
   FROM portfolioproject..Shopping_Trends_23_Copy 
   GROUP BY Gender


--Review count between Male and Female shopper
SELECT Gender,COUNT(Review_Rating) AS ReviewCount
   FROM portfolioproject..Shopping_Trends_23_Copy 
   GROUP BY Gender
   

--What was purchased the most among Male
SELECT Gender,Item_purchased, Category, COUNT(Item_purchased) AS ItemPurchasedCount
   FROM portfolioproject..Shopping_Trends_23_Copy
   WHERE Gender = 'Male' 
   GROUP BY Gender, Item_purchased, Category
   ORDER BY ItemPurchasedCount Desc

--A look at what's purchased the most among Female
SELECT Gender,Item_purchased, Category, COUNT(Item_purchased) AS ItemPurchasedCount
   FROM portfolioproject..Shopping_Trends_23_Copy
   WHERE Gender = 'Female' 
   GROUP BY Gender, Item_purchased, Category
   ORDER BY ItemPurchasedCount Desc

--Total Spent By Both Sex during each season
SELECT Season, SUM(Purchase_Amount_USD)  AS AmountSpent
   FROM portfolioproject..Shopping_Trends_23_Copy
   GROUP BY Season

--Amount Spent seperated By Gender In each Seasons (This gives insight on who spends the most in each season)
SELECT Gender, Season, SUM(Purchase_Amount_USD) AS TotalPurchaseBySeason
   From portfolioproject..Shopping_Trends_23_Copy
   WHERE Gender = 'Male' OR  Gender = 'Female'
   GROUP BY Gender, Season 
   ORDER BY Gender

--Frequency of Purchase between Male and Female
SELECT Gender, Frequency_of_Purchases
   FROM portfolioproject..Shopping_Trends_23_Copy

	
--Method of payment by Gender
SELECT Gender,Age, payment_method
   FROM portfolioproject..Shopping_Trends_23_Copy
   GROUP BY Gender, Age, payment_method
	

--Amount spent by age and method	
SELECT Age, payment_method, SUM(Purchase_Amount_USD)  AS AgeGroupSpending
   FROM portfolioproject..Shopping_Trends_23_Copy
   GROUP BY Age, payment_method
	 








   










  
