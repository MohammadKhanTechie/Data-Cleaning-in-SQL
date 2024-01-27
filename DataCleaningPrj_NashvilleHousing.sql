/*
Cleaning data in SQL queries
*/
select * from ProjectPortfolio.dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDateConverted, CONVERT(DATE, SaleDate)
from ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)

-------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data
Select PropertyAddress
from ProjectPortfolio..NashvilleHousing
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From ProjectPortfolio.dbo.NashvilleHousing a
JOIN ProjectPortfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
From ProjectPortfolio.dbo.NashvilleHousing a
JOIN ProjectPortfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress
from ProjectPortfolio..NashvilleHousing
where PropertyAddress is null

Select substring(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
substring(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) as Address
from ProjectPortfolio..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))
                        
select *
from ProjectPortfolio..NashvilleHousing

select owneraddress
from ProjectPortfolio.dbo.NashvilleHousing

select parsename(replace(owneraddress, ',', '.'), 3),
parsename(replace(owneraddress, ',', '.'), 2),
parsename(replace(owneraddress, ',', '.'), 1)
from ProjectPortfolio..NashvilleHousing

ALTER TABLE nashvillehousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE nashvillehousing
Add OWnerSplitCity nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',', '.'), 2)

ALTER TABLE nashvillehousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',', '.'), 1)

select *
from ProjectPortfolio.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(soldasvacant), Count(soldasvacant)
from ProjectPortfolio.dbo.NashvilleHousing
group by soldasvacant
order by 2

select soldasvacant, Case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	End
from ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	End
--------------------------------------------------------------------------------------------------------------
--Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 Propertyaddress, 
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) row_num
From ProjectPortfolio.dbo.NashvilleHousing
)
Delete
from RowNumCTE
Where row_num > 1
Order by PropertyAddress

--------------------------------------------------------------------------------------------------------------
--Delete Unused Columns

Select * 
from ProjectPortfolio.dbo.NashvilleHousing

ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate











