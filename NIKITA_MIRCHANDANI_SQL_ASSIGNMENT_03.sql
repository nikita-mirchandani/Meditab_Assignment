
---------------------==========================ASSIGNMENT-03=========================------------------------------------
--*API - 1 : CREATE/INSERT
Create function generate_primary_key(FIRST_NAME VARCHAR(20), LAST_NAME VARCHAR(20),MIDDLE_NAME VARCHAR(20),DOB DATE, Sex INT)  
returns int  
language plpgsql  
as  
$$  
Declare 
primary_key integer;
Begin  
  INSERT INTO Patient(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,SEX) values(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,Sex) returning Patient_id into primary_key;
  return primary_key;  
End;  
$$;  

SELECT generate_primary_key('ruchit','shah','nehalbhai','2002-01-01',1);
SELECT generate_primary_key('Dhruvil','Chaudhary','M','2002-11-12',1);
SELECT generate_primary_key('Dhruv','shah','M','2002-11-12',1);
SELECT * from Patient;

--*API - 2 : GETBYID
create or replace function GetById(patientid int)
returns table (
	patient_id int,
	firstname varchar,
	lastname varchar,
	middlename varchar,
	sex_id int,
	dob date
)
language plpgsql
as
$$
declare 
 GetById varchar;
 begin
     GetById := 'select PATIENT_ID ,FIRST_NAME , LAST_NAME,MIDDLE_NAME,SEX,DOB
            from Patient where isDeleted = false and PATIENT_ID = '|| $1;
     raise notice '%',GetById; 
    return query execute GetById using patient_id;
 end;
$$
select * from GetById(1);

--*API - 3 : UPDATE
create or replace function UpdateEntry(
                patient_id int,
                first_name varchar,
                last_name varchar,
                middle_name varchar,
                sex varchar,
                dob date
                )
returns table (
                patientid int,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                dateofbirth date
)
language plpgsql
as
$$
declare 
	_query varchar :='';
 	_update varchar:= 'update Patient set FIRST_NAME = $2,LAST_NAME = $3, MIDDLE_NAME = $4,SEX=(';
 	_select varchar:= 'select sex_id from sex where GENDER = $5),';
 begin
     _query := _update || _select ||'dob=$6 where patient_id = $1 and isdeleted= false returning patient_id,first_name,last_name,middle_name,sex,dob';
     raise notice '%',_query;
     return query execute _query using patient_id,first_name,last_name,middle_name,sex,dob;
 end;
$$
select * from UpdateEntry(1,'Nikita','Mirchandani','Manojkumar','female','2002-01-10');
select * from patient ;
select * from SEX;

--*API - 4 : DELETE
create or replace function DeleteEntry(
                patientid int
   )
	returns table (
                patient_id int,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                dob date
)
language plpgsql
as
$$
declare 
 deletedEntry varchar;
 begin
     deletedEntry := 'update Patient set isDeleted = true where PATIENT_ID= '||$1||' returning  patient_id,FIRST_NAME , LAST_NAME,MIDDLE_NAME,SEX,DOB';
     raise notice '%',deletedEntry; 
    return query execute deletedEntry using patient_id;
 end;
$$
select * from DeleteEntry(5);

--*API - 5 : GETLIST USING PAGING AND SORTING

CREATE OR REPLACE FUNCTION getlist(
 PageNumber integer default 1 ,
 PageSize integer default 20,
 orderby VARCHAR default 'Patient.patient_id'
 )
 RETURNS TABLE (
  LAST_NAME varchar,
  FIRST_NAME varchar,
  SEX varchar,
  DOB date
) AS
$BODY$
 declare
 query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON 
Patient.SEX = SEX.SEX_ID where Patient.isdeleted=false and 1=1 '; 

BEGIN
	query1 := query1 	
	|| ' ORDER BY '||$3 ||' asc limit $2 OFFSET (($1 - 1) * $2);';	
--	raise notice 'sql %' , query1;	
	RETURN QUERY execute query1 using PageNumber,PageSize,orderby;
END;
$BODY$
LANGUAGE plpgsql;

select * from getlist(PageNumber=>1,PageSize=>5,orderby=>'Patient.FIRST_NAME');
select * from getlist();