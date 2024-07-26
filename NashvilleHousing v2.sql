--A glance at the dataset
Select *
From portfolioproject..NashvilleHousing


--Standardize Date Format
--This script here didnt work
Select SaleDate, CONVERT(Date, SaleDate)
From portfolioproject..NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)


--Alternate script to convert SaleDate
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate Property Address Data
Select *
From portfolioproject..NashvilleHousing
--where PropertyAddress is null
Order by ParcelID


--Joined table by Column using the "UniqueID"
-- Update columns where Unique ID is the same but the property address is null
Select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
From portfolioproject..NashvilleHousing  A
JOIN portfolioproject..NashvilleHousing  B
    on A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[uniqueID]
Where A.PropertyAddress is null


Update A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
From portfolioproject..NashvilleHousing  A
JOIN portfolioproject..NashvilleHousing  B
    on A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[uniqueID]
Where A.PropertyAddress is null

------------------------------------------------------------------------------------------------

--Breaking out the Address into Individual Columns (Address, City , State)
--First Example
Select *
From portfolioproject..NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM portfolioproject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



--Another Example to breakout value in column without using SUBSTRING
--Example 2
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM portfolioproject..NashvilleHousing

--Adding those splits into separate columns

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



--Change Y and N to Yes and No in "Sold as Vacant" Field
--First identify how many of this issue I have

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolioproject..NashvilleHousing
Group by SoldAsVacant
Order by 2

--The Change
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From portfolioproject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SoldAsVacantNew Nvarchar(255);

Update portfolioproject..NashvilleHousing
SET SoldAsVacantNew =  CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END



--Remove Duplicates 
WITH RowNumCTE AS (
Select *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				    UniqueID
					) row_num

From PortfolioProject..NashvilleHousing
)
Select *
From RowNumCTE
where row_num > 1
Order by PropertyAddress



--Delete Unused Columns

Select *
From portfolioproject.. NashvilleHousing

ALTER TABLE portfolioproject..NashvilleHousing
DROP COLUMN SaleDate





