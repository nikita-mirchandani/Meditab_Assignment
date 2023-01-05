
---------------------==========================ASSIGNMENT-02=========================------------------------------------
--*Query1

CREATE or REPLACE VIEW demographics AS
    SELECT Patient.FIRST_NAME,Patient.LAST_NAME,Patient.MIDDLE_NAME,Patient.DOB,Patient.CHART_NUMBER,Patient.SEX,RACE.RACE_ID,ADDRESS.PRIMARY_ADDRESS,PHONE.PRIMARY_PHONE,FAX.PRIMARY_FAX
    FROM Patient 
    LEFT JOIN SEX ON Patient.SEX = SEX.SEX_ID
    LEFT JOIN RACE ON RACE.PATIENT_ID =  Patient.PATIENT_ID 
    LEFT JOIN ADDRESS ON Patient.PATIENT_ID = ADDRESS.PATIENT_ID 
    LEFT JOIN PREFERENCE_TABLE ON PREFERENCE_TABLE.PATIENT_ID= patient.PATIENT_ID
    LEFT JOIN PREFERENCE_TYPE_TABLE ON PREFERENCE_TABLE.PREF_ID = PREFERENCE_TYPE_TABLE.PREF_ID AND PREFERENCE_TYPE_TABLE.PREF_ID=1
    LEFT JOIN FAX ON PREFERENCE_TABLE.FAX_ID = FAX.FAX_ID
    LEFT JOIN PHONE ON PREFERENCE_TABLE.PHONE_ID = PHONE.PHONE_ID 
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

Begin  
  INSERT INTO Patient(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,SEX) values(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,Sex);
  return (SELECT PATIENT_ID FROM Patient ORDER BY created_on DESC LIMIT 1);  
End;  
$$;  

SELECT generate_primary_key('ruchit','shah','M','2002-01-01',1);
SELECT generate_primary_key('Dhruvil','shah','M','2002-01-01',1);
SELECT generate_primary_key('Dhruvil','shah','M','2002-01-01',2);
SELECT generate_primary_key('Raj','chopda','M','2002-01-01',1);
SELECT * from Patient;


--*Query4
/*implemented in 2 ways(2 functions) : paging(have to specify argument field in call) and duplicate paging(no mention of column field during function call)*/

--1st way 
CREATE OR REPLACE FUNCTION paging(
 PageNumber INTEGER = NULL,
 PageSize INTEGER = NULL,
 lname VARCHAR default null,
 fname VARCHAR default null,
 _sex VARCHAR default null,
 do_b date default null
 )
 RETURNS TABLE (
  LAST_NAME varchar,
  FIRST_NAME varchar,
  SEX varchar,
  DOB date
) AS
 $BODY$
 BEGIN
  RETURN QUERY
  SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON Patient.SEX = SEX.SEX_ID
  where
  (
  case 
	  when lname is null and fname is null and _sex is null and do_b is null 
	  then true
	 else
	  case 
		  when lname is not null 
		  then Patient.LAST_NAME=lname
		   when fname is not null 
		  then Patient.FIRST_NAME=fname
		  when _sex is not null 
		  then SEX.GENDER=_sex
		  when do_b is not null 
		  then Patient.DOB = do_b
	  end
	end
	  )
  ORDER BY LAST_NAME ASC ,FIRST_NAME ASC, SEX.GENDER ASC, DOB ASC
  LIMIT PageSize
  OFFSET ((PageNumber-1) * PageSize);
END;
$BODY$
LANGUAGE plpgsql;
--working for all below conditions
Select * from paging(1,4,lname=>'shah');
Select * from paging(1,4,fname=>'NIKITA');
Select * from paging(1,3,_sex=>'male');
Select * from paging(1,10,do_b=>'2002-01-01');
Select * from paging(1,10);

--Another(2nd) way 
CREATE OR REPLACE FUNCTION duplicate_paging(
 PageNumber INTEGER = NULL,
 PageSize INTEGER = NULL,
 id VARCHAR default null
 )
 RETURNS TABLE (
  LAST_NAME varchar,
  FIRST_NAME varchar,
  SEX varchar,
  DOB date
) AS
 $BODY$
 BEGIN
  RETURN QUERY
  SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON Patient.SEX = SEX.SEX_ID
  where  (
  case 
	  when id is null 
	  then true
	  when id is not null then
	  case 
		  when id in (Patient.FIRST_NAME,Patient.LAST_NAME,SEX.GENDER)
		  then true
		  when id in (Patient.DOB::VARCHAR)
		  then true
	   end
  end
	)
  ORDER BY LAST_NAME ASC ,FIRST_NAME ASC, SEX.GENDER ASC, DOB ASC
  LIMIT PageSize
  OFFSET ((PageNumber-1) * PageSize);
END;
$BODY$
LANGUAGE plpgsql;

--shows according to fname matched
Select * from duplicate_paging(1,10,'NIKITA');

--shows according to lname matched
Select * from duplicate_paging(1,10,'shah');

--shows according to sex matched
Select * from duplicate_paging(1,10,'female');

--shows according to date matched
Select * from duplicate_paging(1,10,'2002-01-01');

--shows all records
Select * from duplicate_paging(1,10,null);
Select * from duplicate_paging(1,11);

--*Query5
SELECT
              p.FIRST_NAME,Ph.PHONE_NUMBER,add.ADDRESS_ID
FROM
              Patient p
              INNER JOIN ADDRESS add ON add.PATIENT_ID = P.PATIENT_ID
              INNER JOIN Phone Ph ON ph.ADDRESS_ID = add.ADDRESS_ID
WHERE Ph.PHONE_NUMBER = '3355668822';









