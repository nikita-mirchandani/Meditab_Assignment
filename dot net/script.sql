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
  isDeleted boolean default false,
  created_on timestamp default CURRENT_TIMESTAMP not null,
  CONSTRAINT sex_constraint FOREIGN KEY(SEX) REFERENCES SEX(SEX_ID)
);
SET timezone = 'Asia/Calcutta';
ALTER TABLE Patient ADD suburb VARCHAR2(100);
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
insert into preference_type_table(PREFERENCE_TYPE) values('primary');
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
    LEFT JOIN PREFERENCE_TYPE_TABLE ON PREFERENCE_TABLE.PREF_ID = PREFERENCE_TYPE_TABLE.PREF_ID AND PREFERENCE_TYPE_TABLE.preference_type ='primary'
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
primary_key integer;
Begin  
  INSERT INTO Patient(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,SEX) values(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,Sex) returning Patient_id into primary_key;
  return primary_key;  
End;  
$$;  

SELECT generate_primary_key('ruchit','shah','M','2002-01-01',1);
SELECT generate_primary_key('Dhruvil','shah','M','2002-01-01',1);
SELECT generate_primary_key('Dhruvil','shah','M','2002-01-01',2);
SELECT generate_primary_key('Raj','chopda','M','2002-01-01',1);
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
	|| case when $4 is not null then ' and Patient.FIRST_NAME ='''|| $4 || '''' else ' ' end		
	|| case when $3 is not null then ' and Patient.LAST_NAME ='''|| $3 || '''' else ' ' end		
	|| case when $5 is not null then ' and SEX.GENDER ='''|| $5 || '''' else ' ' end		
	|| case when $6 is not null then ' and Patient.DOB ='''|| $6 || '''' else  ' 'end		
	|| ' ORDER BY ' || $7 || ' asc limit ' || $2 || ' OFFSET ((' || $1 || '-1)*'|| $2 || ');';	
	raise notice 'sql %' , query1;	
	RETURN QUERY execute query1;
END;
$BODY$
LANGUAGE plpgsql;
SELECT * from search_function(fname=>'NIKITA');
select * from search_function(lname=>'shah');
select * from search_function(_sex=>'male');
select * from search_function(do_b=>'2002-01-01');
select * from search_function();
--
--create  or replace function  
--search_patient    
--             (
--             PageNumber INTEGER = 1,
--			 PageSize INTEGER = 20,
--			 lname VARCHAR default null,
--			 fname VARCHAR default null,
--			 _sex VARCHAR default null,
--			 do_b varchar default null,
--			 orderby VARCHAR default 'Patient.patient_id')
--returns table(     
--  LAST_NAME varchar,
--  FIRST_NAME varchar,
--  SEX varchar,
--  DOB date
--)
--language plpgsql
--as
--$$
--declare 
--query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON Patient.SEX = SEX.SEX_ID where 1=1 ';
--conditional varchar(3000) := '';
-- 
--begin
--    if fname != '' then
--         conditional := 'and  Patient.FIRST_NAME = '''||fname||'''';
--    end if;
--    if lname != '' then 
--            conditional := conditional||' and Patient.LAST_NAME = '''||lname||'''';
--        
--    end if;
--    if _sex != '' then 
--            conditional := conditional||' and SEX.GENDER = '''||_sex||'''';
--    end if;
--    if do_b != '' then 
--            conditional := conditional||' and Patient.DOB = '''||do_b||'''';
--        
--    end if;
--    
--    query1 := query1 || conditional||' ORDER BY '||orderby||' ASC LIMIT '|| PageSize ||' OFFSET (('||PageNumber||'-1) *'|| PageSize||')';
--    raise notice 'sql %' , query1;
--    return query execute query1;
--end;
--$$
--
--select * from search_patient(fname=>'NIKITA');
--select * from search_patient(lname=>'shah');
--select * from search_patient(_sex=>'male');
--select * from search_patient(do_b=>'2002-01-01');
--select * from search_patient();

--*Query5
SELECT
              p.FIRST_NAME,Ph.PHONE_NUMBER,add.ADDRESS_ID
FROM
              Patient p
              INNER JOIN ADDRESS add ON add.PATIENT_ID = P.PATIENT_ID
              INNER JOIN Phone Ph ON ph.ADDRESS_ID = add.ADDRESS_ID
WHERE Ph.PHONE_NUMBER = '3355668822';






