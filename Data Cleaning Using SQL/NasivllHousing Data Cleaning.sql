-------Cleaning Data in SQL Queries

USE [NashvilleHousing];
GO

select*
from Nashivll_Housing

---------------------------------------------
-- Standardize Date Format

ALTER TABLE Nashivll_Housing
Add SaleDateConverted Date;

update Nashivll_Housing
set SaleDateConverted = convert(Date,SaleDate)

select SaleDate, SaleDateConverted
from Nashivll_Housing

--------------------------------------------------

-- Populate Property Address data

select a.ParcelID, a.PropertyAddress, b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
from   Nashivll_Housing a
join  Nashivll_Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
from   Nashivll_Housing a
join  Nashivll_Housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

select  ParcelID   , PropertyAddress 
from   Nashivll_Housing
where PropertyAddress is null

-----------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

Select
PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2) as PropertysplitAdress
,PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1) as PropertyCity
From Nashivll_Housing

alter table Nashivll_Housing
add PropertysplitAddress varchar(255)

alter table Nashivll_Housing
add PropertyCity varchar(255)

update Nashivll_Housing
set PropertysplitAddress= PARSENAME(replace(PropertyAddress, ',' , '.'),1) 

update Nashivll_Housing
set PropertyCity= PARSENAME(replace(PropertyAddress, ',' , '.'),2)

select*
from Nashivll_Housing

---------------------------------------------------------------

select 
PARSENAME(replace(ownerAddress , ',' , '.' ),3) as ownersplitAdress,
PARSENAME(replace(ownerAddress , ',' , '.' ),2) as ownerCity,
PARSENAME(replace(ownerAddress , ',' , '.' ),1) as ownerState
from Nashivll_Housing

-----------------------------------------------------------
ALTER TABLE Nashivll_Housing
Add ownersplitAdress Nvarchar(255);

Update Nashivll_Housing
SET ownersplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashivll_Housing
Add OwnerSplitCity Nvarchar(255);

Update Nashivll_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashivll_Housing
Add OwnerSplitState Nvarchar(255);

Update Nashivll_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select*
from Nashivll_Housing

------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant) , count(SoldAsVacant)
from Nashivll_Housing
group by SoldAsVacant
order by 2

update  Nashivll_Housing
set SoldAsVacant = 
				case  when SoldAsVacant = 'Y' THEN 'Yes'
				when SoldAsVacant = 'N' THEN 'NO'
				ELSE SoldAsVacant
				end
----------------------------------------------------------------------------
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

From Nashivll_Housing
)

Delete
From RowNumCTE
Where row_num > 1

------------------------------------------------------------------
-- Delete Unused Columns



Select *
From Nashivll_Housing


ALTER TABLE Nashivll_Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

------------------------------------------------------------------------------------


















