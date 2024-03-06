/*   Cleaning Data in SQL Queries   */


Select *
From Projects.dbo.NashvilleHousing


-- Standardize Date Format

UPDATE NashvilleHousing
SET SaleDate = CAST(SaleDate AS Date)
Select *
From Projects.dbo.NashvilleHousing



--Populate missing property address Data

UPDATE nh
SET nh.PropertyAddress = nh2.PropertyAddress
FROM NashvilleHousing nh
INNER JOIN (SELECT ParcelID, PropertyAddress FROM NashvilleHousing WHERE PropertyAddress IS NOT NULL) nh2
ON nh.ParcelID = nh2.ParcelID
WHERE nh.PropertyAddress IS NULL

Select *
From Projects.dbo.NashvilleHousing


--Split Address into Individual Columns:
ALTER TABLE NashvilleHousing
ADD StreetAddress NVARCHAR(255),
    City NVARCHAR(255),
    State NVARCHAR(255);

UPDATE NashvilleHousing
SET StreetAddress = LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1),
    City = LTRIM(RTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) - CHARINDEX(',', PropertyAddress) - 1))),
    State = LTRIM(RTRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) + 1, LEN(PropertyAddress))))

Select *
From Projects.dbo.NashvilleHousing


--Change 'Y' and 'N' to 'Yes' and 'No':

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant 
END

Select *
From Projects.dbo.NashvilleHousing


--Remove Duplicates

;WITH Dupes AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
    ORDER BY UniqueID) AS RowNum
  FROM NashvilleHousing
)
DELETE FROM Dupes WHERE RowNum > 1

Select *
From Projects.dbo.NashvilleHousing


--Delete Unused Columns

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, 
            TaxDistrict, 
            PropertyAddress, 
            SaleDate;

Select *
From Projects.dbo.NashvilleHousing
