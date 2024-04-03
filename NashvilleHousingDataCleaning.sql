SELECT *
FROM NashvilleHousing

-- Standardize Date Format
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)


SELECT SaleDateConverted
FROM NashvilleHousing

-- Populate Property Address Data
SELECT *
FROM NashvilleHousing
ORDER by ParcelID 

SELECT n1.ParcelID, n1.PropertyAddress, n2.ParcelID, n2.PropertyAddress, ISNULL(n1.PropertyAddress, n2.PropertyAddress)
FROM NashvilleHousing n1
JOIN NashvilleHousing n2
ON n1.ParcelID = n2.ParcelID
AND n1.[UniqueID ]<>n2.[UniqueID ]
WHERE n1.PropertyAddress is null

UPDATE n1
SET PropertyAddress = ISNULL(n1.PropertyAddress, n2.PropertyAddress)
FROM NashvilleHousing n1
JOIN NashvilleHousing n2
ON n1.ParcelID = n2.ParcelID
AND n1.[UniqueID ]<>n2.[UniqueID ]
WHERE n1.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) -1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertyStreet Nvarchar(255);

UPDATE NashvilleHousing
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertyCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) -1, LEN(PropertyAddress))

SELECT * FROM NashvilleHousing

Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerStreet Nvarchar(255);

Update NashvilleHousing
SET  OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



SELECT * FROM NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates

WITH RowNumCTE AS(
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
From NashvilleHousing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
From NashvilleHousing


