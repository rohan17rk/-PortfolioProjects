/*

Cleaning Data in SQL Queries

*/

----------------------------------------------------------------------------------------------------
-- Standardize date Formate:

Select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------------------------------
-- Populate Property Address date

Select *
from NashvilleHousing
order by parcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULl(a.propertyAddress,b.PropertyAddress)
from NashvilleHousing as a
Join NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULl(a.propertyAddress,b.PropertyAddress)
from NashvilleHousing as a
Join NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City , State)

Select PropertyAddress,
SUBSTRING(propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(propertyaddress, CHARINDEX(',',PropertyAddress) +1, len(propertyaddress)) as address

from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySpiltAddress nvarchar(255);

Update NashvilleHousing
set PropertySpiltAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySpiltcity nvarchar(255);

Update NashvilleHousing
set PropertySpiltcity = SUBSTRING(propertyaddress, CHARINDEX(',',PropertyAddress) +1, len(propertyaddress))

Select PropertyspiltCity,PropertyspiltAddress,PropertyAddress
from NashvilleHousing


Select OwnerAddress
from NashvilleHousing

Select
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSpiltAddress nvarchar(255);

Update NashvilleHousing
set OwnerSpiltAddress = PARSENAME(replace(owneraddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSpiltcity nvarchar(255);

Update NashvilleHousing
set OwnerSpiltcity = PARSENAME(replace(owneraddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSpiltState nvarchar(255);

Update NashvilleHousing
set OwnerSpiltState = PARSENAME(replace(owneraddress,',','.'),1)

Select OwnerSpiltState,OwnerSpiltcity,OwnerSpiltaddress
from NashvilleHousing;

----------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold" and " Vacant" field

Select distinct(SoldAsVacant), count(SoldasVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
	case When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldAsVacant
		 end
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = case When SoldAsVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant

----------------------------------------------------------------------------------------------------

--Remove Duplicates


With RowNumCTE as(
Select *,
	ROW_NUMBER() Over(Partition by ParcelID, SalePrice,SaleDate,LegalReference order by uniqueID) row_num
from NashvilleHousing
)

Delete 
from RowNumCTE
where row_num>1


----------------------------------------------------------------------------------------------------

--Delete Unused Column

Select * 
from NashvilleHousing


Alter table NashvilleHousing
Drop Column OwnerAddress, PropertyAddress










						end













