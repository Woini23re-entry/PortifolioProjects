/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortifolioProjectsql].[dbo].[NashvilleHousing]

  select *
  from PortifolioProjectsql..NashvilleHousing

  --standerdized date Format

  select SaleDate, convert(Date,SaleDate)as SaleDateCorrected
  from PortifolioProjectsql..NashvilleHousing

  --OR-----------

  Alter Table PortifolioProjectsql..NashvilleHousing
  Add SaleDateConverted Date;

  select saleDateConverted
  from PortifolioProjectsql..NashvilleHousing

  update NashvilleHousing
  SET SaleDateConverted =convert(Date,SaleDate)

  --Populatin property address in relation with ParceID 

  select PropertyAddress, OwnerAddress, ownerName
  from PortifolioProjectsql..NashvilleHousing
  where PropertyAddress is null

  --to populate property adress from ParcelId for Null values 

  select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress
  from PortifolioProjectsql..NashvilleHousing as a
  Join PortifolioProjectsql..NashvilleHousing as b
     on a.ParcelID =b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID ]
  where a.PropertyAddress is null

  update a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
   from PortifolioProjectsql..NashvilleHousing as a
  Join PortifolioProjectsql..NashvilleHousing as b
     on a.ParcelID =b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID ]
  where a.PropertyAddress is null

  select PropertyAddress
  from PortifolioProjectsql..NashvilleHousing
  where PropertyAddress is null 

  --Spliting Property Address field -------

  Select propertyAddress
  from PortifolioProjectsql..NashvilleHousing

  select propertyAddress, 
       SUBSTRING(propertyAddress, 1, charindex(',',propertyAddress) -1) as Address
	   , SUBSTRING(propertyAddress, charindex(',',propertyAddress) +1, LEN(propertyAddress)) as Address
 from PortifolioProjectsql..NashvilleHousing  

 --after spliting  we need to put in to the table as a new columon 

 Alter Table PortifolioProjectsql..NashvilleHousing
  Add PropertyAddressCorrected Varchar(255);

 
  update NashvilleHousing
  SET PropertyAddressCorrected = SUBSTRING(propertyAddress, 1, charindex(',',propertyAddress) -1) 
 
  Alter Table PortifolioProjectsql..NashvilleHousing
  Add PropertyCityCorrected Varchar(255);

 
  update NashvilleHousing
  SET PropertyCityCorrected = SUBSTRING(propertyAddress, charindex(',',propertyAddress) +1, LEN(propertyAddress))


  select *
  from PortifolioProjectsql..NashvilleHousing

  ---using parsname to splite owner adress---

  select 
  PARSENAME(Replace(OwnerAddress, ',', '.'),3)
  ,  PARSENAME(Replace(OwnerAddress, ',', '.'),2)
  ,  PARSENAME(Replace(OwnerAddress, ',', '.'),1)
  from PortifolioProjectsql..NashvilleHousing


   Alter Table PortifolioProjectsql..NashvilleHousing
  Add OwnerAddressCorrecetd Varchar(255);

 
  update NashvilleHousing
  SET OwnerAddressCorrecetd = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

   Alter Table PortifolioProjectsql..NashvilleHousing
  Add OwnerCityCorrected Varchar(255);

 
  update NashvilleHousing
  SET OwnerCityCorrected =PARSENAME(Replace(OwnerAddress, ',', '.'),2)

   Alter Table PortifolioProjectsql..NashvilleHousing
  Add OwnerState Varchar(255);

 
  update NashvilleHousing
  SET OwnerState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)
   
select *
from PortifolioProjectsql..NashvilleHousing

-- Using a case stament to change Y and N in to Yes and No respectively 

select distinct (soldAsVacant),count(soldAsVacant)
from  PortifolioProjectsql..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
   CASE when soldAsVacant = 'Y' THEN 'Yes'
      when soldAsVacant ='N' THEN 'No'
	  Else SoldASVacant
	  END
from  PortifolioProjectsql..NashvilleHousing

 update NashvilleHousing
  SET SoldAsVacant =  CASE when soldAsVacant = 'Y' THEN 'Yes'
      when soldAsVacant ='N' THEN 'No'
	  Else SoldASVacant
	  END

-- Remove Duplicate (CTE , finding duplicate and remove)

with RowNumCTE as(
select *,
  ROW_NUMBER() over(
  partition by ParcelId,
               PropertyAddress,
			   salePrice,
			   saleDate,
			   LegalReference
			   order by 
			       uniqueId
				   ) as row_num

from PortifolioProjectsql..NashvilleHousing

)
select *
from RowNumCTE
where row_num >1 
order by PropertyAddress


-- To delete the duplicate


Delete 
from RowNumCTE
where row_num >1 

--Deleting unused columns 

Alter Table PortifolioProjectsql..NashvilleHousing
Drop column ownerAddress, PropertyAddress, TaxDistrict


select *
from PortifolioProjectsql..NashvilleHousing

Alter Table PortifolioProjectsql..NashvilleHousing
drop column saleDate