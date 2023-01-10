
---------------------==========================ASSIGNMENT-02=========================------------------------------------
--*Query1

CREATE or REPLACE VIEW demographics AS
    SELECT Patient.patient_id,Patient.FIRST_NAME,Patient.LAST_NAME,Patient.MIDDLE_NAME,Patient.DOB,Patient.CHART_NUMBER,SEX.gender,RACE.RACE_TYPE,ADDRESS.country,ADDRESS.STREET,ADDRESS.ZIP,ADDRESS.CITY,ADDRESS.STATE,PHONE.PHONE_NUMBER,FAX.FAX_NUMBER
    FROM Patient 
    LEFT JOIN SEX ON Patient.SEX = SEX.SEX_ID
    LEFT JOIN RACE ON RACE.PATIENT_ID =  Patient.PATIENT_ID 
    LEFT JOIN RACE_TYPE ON RACE.race_id  =  RACE_TYPE.race_id 
    LEFT JOIN PREFERENCE_TYPE_TABLE ON PREFERENCE_TYPE_TABLE.preference_type ='primary'
    LEFT JOIN PREFERENCE_TABLE ON  PREFERENCE_TABLE.PREF_ID = PREFERENCE_TYPE_TABLE.PREF_ID and PREFERENCE_TABLE.PATIENT_ID= patient.PATIENT_ID
    LEFT JOIN ADDRESS ON Patient.PATIENT_ID = ADDRESS.PATIENT_ID and ADDRESS.address_id = PREFERENCE_TABLE.address_id 
    LEFT JOIN FAX ON PREFERENCE_TABLE.FAX_ID = FAX.FAX_ID and ADDRESS.address_id = fax.address_id 
    LEFT JOIN PHONE ON PREFERENCE_TABLE.PHONE_ID = PHONE.PHONE_ID and ADDRESS.address_id = PHONE.address_id 
     ;

SELECT * FROM demographics;

--*Query2
SELECT FIRST_NAME,LAST_NAME,DOB,SEX,COUNT(*) 
FROM Patient 
GROUP BY FIRST_NAME,LAST_NAME,DOB,SEX;


--*Query3
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


--*Query4

CREATE OR REPLACE FUNCTION search_function(
 PageNumber integer default 1 ,
 PageSize integer default 20,
 lname VARCHAR default null,
 fname VARCHAR default null,
 _sex VARCHAR default null,
 do_b date default null,
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
 query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON Patient.SEX = SEX.SEX_ID where 1=1 '; 

BEGIN
	query1 := query1 
	|| case when $4 is not null then ' and Patient.FIRST_NAME = $4' else ' ' end		
	|| case when $3 is not null then ' and Patient.LAST_NAME = $3' else ' ' end		
	|| case when $5 is not null then ' and SEX.GENDER =$5' else ' ' end		
	|| case when $6 is not null then ' and Patient.DOB =$6' else  ' 'end		
	|| ' ORDER BY '||$7 ||' asc limit $2 OFFSET (($1 - 1) * $2);';	
	raise notice 'sql %' , query1;	
	RETURN QUERY execute query1 using PageNumber,PageSize,lname,fname,_sex,do_b,orderby;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * from search_function(fname=>'NIKITA');
select * from search_function(lname=>'shah',orderby=>'Patient.first_name');
select * from search_function(lname=>'shah',orderby=>'Patient.DOB');
select * from search_function(_sex=>'male',orderby=>'Patient.last_name');
select * from search_function(do_b=>'2002-01-01');
select * from search_function();

--*Query5
SELECT
              p.FIRST_NAME,Ph.PHONE_NUMBER,add.ADDRESS_ID
FROM
              Patient p
              INNER JOIN ADDRESS add ON add.PATIENT_ID = P.PATIENT_ID
              INNER JOIN Phone Ph ON ph.ADDRESS_ID = add.ADDRESS_ID
WHERE Ph.PHONE_NUMBER = '3355668822';

