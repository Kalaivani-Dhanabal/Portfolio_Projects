
-----------------------------------------------------------
-- Cleaning Data using MySQL Queries
-----------------------------------------------------------

SELECT * FROM portfolioproject.nashville_houses;

-----------------------------------------------------------
-- Standardize Date Format

SELECT SaleDate  
FROM portfolioproject.nashville_houses;  

UPDATE SaleDate
SET SaleDate = str_to_date(saledate, '%M %d,%Y');

---------------------------------------------------------
-- Populate Property Address Data

SELECT * 
FROM portfolioproject.nashville_houses
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
FROM portfolioproject.nashville_houses a
JOIN portfolioproject.nashville_houses b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID;
-- where a.PropertyAddress = '';

UPDATE portfolioproject.nashville_houses AS a,
portfolioproject.nashville_houses AS b
SET a.PropertyAddress = b.PropertyAddress
WHERE a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
AND a.PropertyAddress = '';


SELECT *
FROM portfolioproject.nashville_houses;

--------------------------------------------------------------------------------------
-- Breaking out the PropertyAddress column into individual columns (Address, City) 
-- from this, PropertyAddress'1808  FOX CHASE DR, GOODLETTSVILLE' to Property_Adress - '1808  FOX CHASE DR,Property_City - 'GOODLETTSVILLE'

SELECT PropertyAddress,
substr(PropertyAddress,1,locate(',',PropertyAddress)-1) AS Property, 
substr(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress)) AS City
FROM portfolioproject.nashville_houses;

ALTER TABLE nashville_houses
ADD Property_Address text;

UPDATE nashville_houses
SET Property_Address = substr(PropertyAddress, 1, locate(',',PropertyAddress)-1);

ALTER TABLE nashville_houses
ADD Property_City text;

UPDATE nashville_houses
SET Property_City = substr(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress));

SELECT Property_Address, Property_City
FROM portfolioproject.nashville_houses;


--------------------------------------------------------------------------------------
-- Breaking out the OwnerAddress column into individual columns (Address, City, State) 
-- from this, OwnerAddress '202  UTLEY DR, GOODLETTSVILLE, TN' to Address - '202  UTLEY DR', City -'GOODLETTSVILLE', State -'TN'


SELECT *
FROM portfolioproject.nashville_houses;

SELECT OwnerAddress,
substring_index(OwnerAddress,',', 1) as Address,
substring_index(substring_index(OwnerAddress,',',-2), ',', 1) as City,
substring_index(OwnerAddress,',',-1) as State
FROM portfolioproject.nashville_houses;


ALTER TABLE nashville_houses
ADD Owner_Address text;

UPDATE nashville_houses
SET Owner_Address = substring_index(OwnerAddress,',', 1); 

ALTER TABLE nashville_houses
ADD Owner_City text;

UPDATE nashville_houses
SET Owner_City = substring_index(substring_index(OwnerAddress,',',-2), ',', 1);

ALTER TABLE nashville_houses
ADD Owner_State text;

UPDATE nashville_houses
SET Owner_State = substring_index(OwnerAddress,',',-1);


----------------------------------------------------------------
-- Changing Y and N to Yes and No in "Sold As Vacant" field
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolioproject.nashville_houses
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END
FROM portfolioproject.nashville_houses;

UPDATE nashville_houses
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END;
     
     
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolioproject.nashville_houses
GROUP BY SoldAsVacant
ORDER BY 2;


---------------------------------------------------------------------
-- Removing Duplicates

SELECT *
FROM portfolioproject.nashville_houses
ORDER BY 5;

WITH RowNumCTE AS(
SELECT *,
	row_number() OVER(
        PARTITION BY ParcelID,
		     Property_Address,
                     SaleDate,
                     SalePrice,
                     LegalReference
		ORDER BY 
			UniqueID
                        )row_num

from portfolioproject.nashville_houses
)

-- SELECT *
DELETE
FROM RowNumCTE
WHERE row_num > 1;
-- ORDER BY Property_Address;

--------------------------------------------------------------------------------
-- Delete Unused columns

SELECT *
FROM portfolioproject.nashville_houses;

ALTER TABLE nashville_houses 
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerAddress;








