use phone;

select * from phone limit 10;

select * from phone

where model is null
or price is null
or sim is null
or processor is null
or ram is null
or battery is null
or battery is null
or camera is null
or card is null
or os is null;

alter table phone
drop column ID;

#add an ID column 
alter table phone
add column ID int auto_increment primary key first;

#removing '?' from price column and move it into integer
SET SQL_SAFE_UPDATES = 0;
UPDATE phone
SET price = CAST(REPLACE(SUBSTRING(price, 2), ',', '') AS DECIMAL(10, 2));

SET SQL_SAFE_UPDATES = 1;
select model, price from phone where model ='OnePlus 11 5G';
select * from phone;
select count(distinct(model)) from phone;

set sql_safe_updates = 0;
Update phone
set processor = Replace(processor, '?', ' '),
	ram = replace(ram, '?', ' '),
	battery = replace(battery,  '?', ' '),
    camera = replace(camera,  '?', ' '),
    card = replace(card,  '?', ' '),
    os = replace(os,  '?', ' ')				Where 1;

update phone
set display = replace(display, '?', ' ');

use phone;
select * from phone;

alter table phone
add column ram_size int unsigned;

set sql_safe_updates = 0;
UPDATE phone
SET ram_size = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ram, ' ', 1), ' ', -1) AS UNSIGNED);

alter table phone
add column inbuilt_storage_size int unsigned;
set sql_safe_updates = 0;

select * from phone;
alter table phone
drop column inbuilt_storage_size;

use phone;
select * from phone;

#working with model columns
alter table phone
add column brand varchar(255),
add column phone_model varchar(255);

set sql_safe_updates = 0;
UPDATE phone
SET
  brand = TRIM(SUBSTRING_INDEX(model, ' ', 1)),
  phone_model = TRIM(SUBSTRING(model, LENGTH(SUBSTRING_INDEX(model, ' ', 1)) + 2));

select model, brand, phone_model from phone;
select count(distinct(brand)) from phone;
select brand, count(*) as brand_count
from phone 
group by brand
order by brand_count desc
limit 5;
select avg(price) as total_single_price from phone where sim like '%';

#work with sim column
alter table phone
add column sim1 varchar(255);

update phone
set sim = TRIM(SUBSTRING_INDEX(sim, ' ', 1));

alter table phone
drop column sim1;

alter table phone
add column storage_size int;

select * from phone;
update phone
set
 storage_size = 
    CASE
      WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(ram, ' ', -2), ' ', -1)) REGEXP '^[0-9]+$'
      THEN CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(ram, ' ', -2), ' ', -1)) AS UNSIGNED)
      ELSE NULL
    END;

select storage_size from phone where storage_size is not null;

#work with battery

alter table phone 
modify column battery_1 decimal(10,2),
modify column fast_charging decimal(10,2);

update phone
set
battery_1 = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(battery, ' ', 1), ' ', -1) AS decimal(10,2));

update phone
set
fast_charging = 
CASE
      WHEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(battery, ' ', -2), ' ', -1)) REGEXP '^[0-9.]+$'
      THEN CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(battery, ' ', -2), ' ', -1)) AS DECIMAL(10, 2))
      ELSE NULL
    END;
    
select * from phone;

alter table phone 
add column camera_1 decimal(10,2);

update phone
set
camera_1 = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(battery, ' ', 1), ' ', -1) AS decimal(10,2));


-- Add new columns for memory card support and Android version
ALTER TABLE phone
ADD COLUMN memory_card_support VARCHAR(20),
ADD COLUMN android_version VARCHAR(10);

-- Update the new columns based on the operatingSystem column
UPDATE phone
SET
  memory_card_support = 
    CASE
      WHEN card LIKE '%Memory Card Supported%'
      THEN 'Supported'
      WHEN card LIKE '%Memory Card Not Supported%'
      THEN 'Not Supported'
      WHEN card LIKE '%Memory Card (Hybrid)%'
      THEN 'Hybrid'
      ELSE NULL
    END,
  android_version = 
    CASE
      WHEN card LIKE 'Android v%'
      THEN TRIM(SUBSTRING_INDEX(card, ' ', -1))
      ELSE NULL
    END;

alter table phone
drop column android_version;

ALTER TABLE phone
ADD COLUMN card_1 VARCHAR(50);

-- Update the new column based on the operatingSystem column
UPDATE phone
SET
   card_1 = 
    CASE
      WHEN card LIKE '%Memory Card Supported%' AND card LIKE 'Android v%'
      THEN CONCAT('Memory Card Supported, Android v', TRIM(SUBSTRING_INDEX(card, ' ', -1)))
      WHEN card LIKE '%Memory Card Supported%'
      THEN 'Memory Card Supported'
      WHEN card LIKE 'Android v%'
      THEN CONCAT('Android v', TRIM(SUBSTRING_INDEX(card, ' ', -1)))
      ELSE NULL
    END;

alter table phone
drop column clock_speed,
drop column storage_size,
drop column fast_charging;

alter table phone
add column operation_system varchar(255);

update phone
set
operation_system = TRIM(SUBSTRING_INDEX(os, ' ', 1));

drop table cleaned_phone;

Create table cleaned_phone as
select ID, brand, phone_model, price, rating, ram_size, battery_1, camera_1, operation_system
from phone;

select * from cleaned_phone
where brand is null
or phone_model is null
or price is null
or rating is null
or ram_size is null
or battery_1 is null
or camera_1 is null
or operation_system is null;


select ID, brand, phone_model, price, rating, ram_size, battery_1, camera_1, operation_system
into outfile 'C:\Users\Т\OneDrive\Pictures\colab.output.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM cleaned_phone;

SELECT TRIM(SPLIT_PART(ram, ',', -1))
FROM phone;

select * from phone;
select * from cleaned_phone;
select * from phone where ID = 298;
select * from cleaned_phone;
select * from cleaned_phone_2;

describe cleaned_phone;
alter table cleaned_phone_2
add column ID int,
add column brand varchar(255),
add column phone_model varchar(255),
add column price decimal(10,2),
add column rating int,
add column operation_system varchar(100);

insert into cleaned_phone_2 (ID, brand, phone_model, price, rating, operation_system)
select brand, phone_model, price, rating, operation_system
from cleaned_phone;

select count(*) from cleaned_phone;

#before that, I should clean data in cleaned_phone table
select * from cleaned_phone;
#seeing missing values in each column
select * from cleaned_phone
where ID is null 
or phone_model is null
or brand is null
or price is null
or rating is null
or operation_system is null;

drop table final_phone;

#so, I've cleaned and extracted some columns in python (pandas library), here is final result
select * from final_phone where brand is null;
delete from final_phone where brand is null;

RENAME TABLE `final_phone(1)` TO final_phone;

#change column types
alter table final_phone 
modify column battery_capacity decimal(10,2);
alter table final_phone 
modify column front_camera decimal(10,2);
select brand, count(brand) from final_phone;

#finding out which brand and operation system popular are
SELECT brand, COUNT(*) AS brand_count
FROM final_phone
GROUP BY brand
ORDER BY brand_count DESC;

select operation_system, count(*) as os_count
from final_phone
group by operation_system
order by os_count desc;

select ram_size, count(*) as ram_size_count
from final_phone
group by ram_size
order by ram_size_count desc;

#according to this, there are some incorrect data in ra_size column. let's modify them
select * from final_phone where ram_size = 64;
update final_phone
set ram_size = 4 where ID = 667 limit 1;
#so, our ram_size colum is so clean.alter

#let's move to storage_size column
select storage_size, count(*) as storage_size_count
from final_phone
group by storage_size
order by storage_size_count desc;

#there are some incorrect data, which are given 132 ram inctead of 128. let's change it
update final_phone
set storage_size = 128 where storage_size = '132.10538373424973' limit 6;
#it has become clean like a crystal.

#move to battery capacity
select * from final_phone where battery_capacity > 7000 or battery_capacity < 2000;
select * from final_phone;

#fast_charging
select count(*) from final_phone where fast_charging = 0;
select brand, fast_charging, count(*) as fast_charging_count 
from final_phone 
where fast_charging >100
group by brand, fast_charging;

select brand, fast_charging, count(*) as fast_charging_count,
case 
	when fast_charging = 0 then 'No fast charging'
    when fast_Charging > 100 then 'fast charging more than 100W'
    when fast_charging between 0 and 100 then 'fast charging is between 0 and 100'
    else 'other'
end as charging_category
from final_phone 
group by brand, fast_charging, charging_Category;

#rating
select * from final_phone where rating > 80;
select brand, rating, count(*) as rating_count 
from final_phone 
where rating >80
group by brand, rating;

select brand, rating,
case 
	when rating between 60 and 70 then 'low rating'
    when rating between 70 and 80 then 'medium rating'
    when rating > 80 then 'high rating'
    else 'other'
end as rating_category
from final_phone
group by brand, rating, rating_category;

select min(rating), avg(rating), max(rating) from final_phone;

#front_Camera
select * from final_phone where front_camera between 10 and 40;
use phone;
select avg(price) as average_price, 
	   avg(rating) as average_rating,
       avg(battery_capacity)
from final_phone;

select * from final_phone;      
select count(*) from final_phone where 
ID is null
or phone_model is null
or price is null
or rating is null
or operation_system is null
or ram_size is null
or storage_size is null
or battery_capacity is null
or fast_charging is null
or front_camera is null;

#so, we've cleaned and corrected incorrect data and data type. Additionally, we've done descriptive analysis
# this means that our data is ready to visualize in tabluae



