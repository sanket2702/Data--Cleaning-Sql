select * from Datacleaning..HousingData

-- changing the date format
select SaleDateConverted from HousingData

update HousingData
Set SaleDate = Convert(date, SaleDate)

Alter table HousingData
add SaleDateConverted Date;

update HousingData
Set SaleDateConverted = Convert(date, SaleDate


-- property address data
select * from housingdata
-- where propertyaddress is null
order by parcelid

-- using self join and printing the duplicated values in parcelid and property address
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from Housingdata a
join Housingdata b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid

-- printing where property address from table 1 is null
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from Housingdata a
join Housingdata b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null


-- replacing null values from propertyadress(table1) with propertyaddress (table2)
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.propertyaddress)
from Housingdata a
join Housingdata b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

-- updating the column ie table 1 property address.

update a
set a.propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from Housingdata a
join Housingdata b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

-- breaking	out address into individual columns (address, city, state)

select propertyaddress
from Datacleaning..HousingData

select SUBSTRING(PropertyAddress, 1, Charindex(',', propertyaddress) -1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(propertyaddress)) as address 
from Datacleaning..HousingData

alter table HousingData
add propertysplitaddress Nvarchar(255);

update HousingData
set propertysplitaddress = SUBSTRING(PropertyAddress, 1, Charindex(',', propertyaddress) -1)

alter table HousingData
add propertysplitcity Nvarchar(255);

update HousingData
set propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(propertyaddress))

select * from HousingData

-- doing the same thing on owner address but in simple way 
select owneraddress from HousingData

select PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from HousingData


alter table HousingData
add ownersplitaddress Nvarchar(255);

update HousingData
set ownersplitaddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

alter table HousingData
add ownersplitcity Nvarchar(255);

update HousingData
set ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

alter table HousingData
add ownersplitstate Nvarchar(255); 

update HousingData
set ownersplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


select * from HousingData

-- change Y and N to yes and no in soldvacant 
select distinct(soldasvacant), count(soldasvacant)
from Datacleaning..HousingData
group by SoldAsVacant
order by 2

select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
       when soldasvacant = 'N' then 'No'
	   else soldasvacant 
	   end
from Datacleaning..HousingData


update Datacleaning..HousingData
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
       when soldasvacant = 'N' then 'No'
	   else soldasvacant 
	   end

with row_numCTE as (
select *, ROW_NUMBER() over (
			partition by ParcelID,
						 PropertyAddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
						 order by
							UniqueID
							) row_num

From Datacleaning..HousingData
)
select *  from row_numCTE
where row_num > 1
-- order by PropertyAddress

select * from Datacleaning..HousingData

-- drop unused columns 

select * from Datacleaning..HousingData

alter table datacleaning..housingdata
drop column OwnerAddress, TaxDistrict, propertyAddress

alter table Datacleaning..HousingData
drop column SaleDate



