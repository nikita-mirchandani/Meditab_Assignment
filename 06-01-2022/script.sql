CREATE TABLE SEX(
  SEX_ID SERIAL PRIMARY KEY,
  GENDER VARCHAR(20)
);
INSERT INTO SEX(GENDER) VALUES('male');
INSERT INTO SEX(GENDER) VALUES('female');
INSERT INTO SEX(GENDER) VALUES('unknown');
SELECT * FROM SEX;

CREATE TABLE PHONE_TYPE(
  PHONE_ID SERIAL PRIMARY KEY,
  PHONE_TYPE VARCHAR(20)
);
INSERT INTO PHONE_TYPE(PHONE_TYPE) VALUES('CELL');
INSERT INTO PHONE_TYPE(PHONE_TYPE) VALUES('LANDLINE');
SELECT * FROM PHONE_TYPE;


CREATE TABLE ADDRESS_TYPES(
  ADDRESS_ID SERIAL PRIMARY KEY,
  ADDRESS_TYPE VARCHAR(20)
);
INSERT INTO ADDRESS_TYPES(ADDRESS_TYPE) VALUES('WORK');
INSERT INTO ADDRESS_TYPES(ADDRESS_TYPE) VALUES('HOME');
SELECT * FROM ADDRESS_TYPES;


CREATE TABLE RACE_TYPE(
  RACE_ID SERIAL PRIMARY KEY,
  RACE_TYPE VARCHAR(20)
);
INSERT INTO RACE_TYPE(RACE_TYPE) VALUES('ASIAN');
INSERT INTO RACE_TYPE(RACE_TYPE) VALUES('AMERICAN');
SELECT * FROM RACE_TYPE;

CREATE TABLE IF NOT EXISTS Patient(
  PATIENT_ID SERIAL primary key,
  CHART_NUMBER VARCHAR(20) NOT null generated always as ('CHART'||PATIENT_ID::text) stored,
  FIRST_NAME VARCHAR(20) NOT NULL,
  LAST_NAME VARCHAR(20) NOT NULL,
  MIDDLE_NAME VARCHAR(20),
  DOB DATE,
  SEX INT,
  created_on timestamp default CURRENT_TIMESTAMP not null,
  CONSTRAINT sex_constraint FOREIGN KEY(SEX) REFERENCES SEX(SEX_ID)
);
SET timezone = 'Asia/Calcutta';
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('NIKITA','MIRCHANDANI','M',2);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('NIKITA','MIRCHANDANI','M',2);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('fb','dv','M',1);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('meet','Vachhani','M',1);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('meet','Patel','M',1);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('meet','Vachhani','M',1);
SELECT * from Patient;

CREATE TABLE RACE(
  RACE_ID SERIAL PRIMARY KEY,
  RACE_TYPE INT NOT NULL,
  PATIENT_ID INT,
  CONSTRAINT race_id FOREIGN KEY(RACE_TYPE) REFERENCES RACE_TYPE(RACE_ID),
  CONSTRAINT patient_id FOREIGN KEY(PATIENT_ID) REFERENCES Patient(PATIENT_ID)
);
INSERT INTO RACE(RACE_TYPE,PATIENT_ID) VALUES(1,'0001');
SELECT * FROM RACE;


CREATE TABLE ADDRESS(
  ADDRESS_ID SERIAL PRIMARY KEY,
  ADDRESS_TYPE INT NOT NULL,
  STREET VARCHAR(20),
  CITY VARCHAR(20),
  ZIP INT,
  STATE VARCHAR(20),
  COUNTRY VARCHAR(20),
  PATIENT_ID INT,
  PRIMARY_ADDRESS BOOLEAN,
  CONSTRAINT user_id FOREIGN KEY(PATIENT_ID) REFERENCES Patient(PATIENT_ID),
  CONSTRAINT ADDRESS_TYPE_CONSTRAINT FOREIGN KEY(ADDRESS_TYPE) REFERENCES ADDRESS_TYPES(ADDRESS_ID)
);

INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID) VALUES(1,'STREET','rajkot',387630,'0001');
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID) VALUES(1,'STREET','rajkot',387630,'0002');
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID) VALUES(1,'STREET','rajkot',387630,'0003');
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID) VALUES(1,'STREET','rajkot',387630,'0004');
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID) VALUES(1,'STREET','rajkot',387630,'0005');
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID) VALUES(1,'STREET','rajkot',387630,'0006');

SELECT * FROM ADDRESS;

CREATE TABLE PHONE(
  PHONE_ID SERIAL PRIMARY KEY,
  PHONE_NUMBER VARCHAR(10) NOT NULL,
  PHONE_TYPE INT,
  PRIMARY_PHONE BOOLEAN,
  ADDRESS_ID INT,
  CONSTRAINT address_id_constraint FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID),
  CONSTRAINT phone_type_constraint FOREIGN KEY(PHONE_TYPE) REFERENCES PHONE_TYPE(PHONE_ID)
);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (8849126581,1,false,1);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (9856982563,1,false,2);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (5588996685,1,false,3);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (7788554411,1,false,4);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (8855226699,1,false,5);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (3355668822,1,false,6);

SELECT * from PHONE;

CREATE TABLE FAX(
  FAX_ID SERIAL PRIMARY KEY,
  FAX_NUMBER VARCHAR(10) NOT NULL,
  PRIMARY_FAX BOOLEAN,
  ADDRESS_ID INT,
  CONSTRAINT address_id_constraint FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID)
);

INSERT into FAX(ADDRESS_ID,FAX_NUMBER,PRIMARY_FAX) VALUES (1,5313,false);
SELECT * from FAX;


CREATE TABLE PREFERENCE_TYPE_TABLE(
  PREF_ID SERIAL PRIMARY KEY,
  PREFERENCE_TYPE varchar(20)
);
insert into preference_type_table(PREFERENCE_TYPE) values('MAILING');
SELECT * from PREFERENCE_TYPE_TABLE;


CREATE TABLE PREFERENCE_TABLE(
  PREF_ID SERIAL PRIMARY KEY,
  ADDRESS_ID INT,
  PATIENT_ID INT,
  PREFERENCE_TYPE INT references PREFERENCE_TYPE_TABLE(PREF_ID),
  PHONE_ID INT,
  FAX_ID INT, 
  CONSTRAINT address_id_constraint FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID),
  CONSTRAINT patient_id_constraint FOREIGN KEY(PATIENT_ID) REFERENCES Patient(PATIENT_ID),
  CONSTRAINT fax_id_constraint FOREIGN KEY(FAX_ID) REFERENCES FAX(FAX_ID),
  CONSTRAINT phone_id_constraint FOREIGN KEY(PHONE_ID) REFERENCES PHONE(PHONE_ID)
);
insert into PREFERENCE_TABLE(ADDRESS_ID,PATIENT_ID,PREFERENCE_TYPE,PHONE_ID,FAX_ID) values(4,'001',1,1,1);
SELECT * from PREFERENCE_TABLE;


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

CREATE OR REPLACE FUNCTION SEARCHING(
 PageNumber INTEGER = NULL,
 PageSize INTEGER = NULL,
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
 query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON Patient.SEX = SEX.SEX_ID ';
 conditional varchar(2000) := 'where 1=1';
 BEGIN
   case 
	  (
	 case
	  when fname is not null 
	  then conditional:= conditional ||' and Patient.FIRST_NAME ='''|| fname || ''''
	  else true
	 end
	 case
	  when lname is not null 
	  then conditional:= conditional ||' and Patient.LAST_NAME ='''|| lname || ''''
	  else true
	 end
	 case
	  when _sex is not null 
	  then conditional:= conditional ||' and SEX.GENDER ='''|| _sex || ''''
	  else true
	end
	case
	  when do_b is not null 
	  then conditional:= conditional ||' and Patient.DOB ='''|| do_b || ''''
	  else true
	end
	)
end
	
	raise notice '%s' query1;
	query1 := query1 || conditional || ' ORDER BY ' || orderby || ' asc limit ' || PageSize || ' OFFSET ((' || PageNumber || '-1)*'|| PageSize || ');'	
	RETURN QUERY execute query1;
END;
$BODY$
LANGUAGE plpgsql;
--working for all below conditions
Select * from SEARCHING(1,4,lname=>'shah');


create  or replace function  
search_patient    
            (
            pageNumber in integer default 1 ,
            pageSize in integer default 20,
            firstName in varchar default null ,
            lastName in varchar default null,
            gender in varchar default null,
            dateofbirth in varchar default null,
            orderby in varchar default 'patient_id')
returns table(     
	LAST_NAME varchar,
  FIRST_NAME varchar,
  SEX varchar,
  DOB date
)
language plpgsql
as
$$
declare 
query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON Patient.SEX = SEX.SEX_ID where 1=1 ';
conditional varchar(3000) := '';
 
begin
    if firstName != '' then
         conditional := 'and  Patient.FIRST_NAME = '''||$3||'''';
    end if;
    if lastName != '' then 
        
            conditional := conditional||' and Patient.LAST_NAME = '''||$4||'''';
        
    end if;
    if gender != '' then 
        
            conditional := conditional||' and SEX.GENDER = '''||$5||'''';
    end if;
    if dateofbirth != '' then 
                    conditional := conditional||' and Patient.DOB = '''||$6||'''';
        
    end if;
    
    query1 := query1||conditional||' ORDER BY '|| $7||' ASC LIMIT '|| pageSize ||' OFFSET (('||pageNumber||'-1) *'|| PageSize||')';
    raise notice 'sql %' , query1;
    return query execute query1;
end;
$$

select * from search_patient(firstName=>'NIKITA');

--*Query5
SELECT
              p.FIRST_NAME,Ph.PHONE_NUMBER,add.ADDRESS_ID
FROM
              Patient p
              INNER JOIN ADDRESS add ON add.PATIENT_ID = P.PATIENT_ID
              INNER JOIN Phone Ph ON ph.ADDRESS_ID = add.ADDRESS_ID
WHERE Ph.PHONE_NUMBER = '3355668822';









