
--##################################################################
-- VALIDATE AND OPTIMIZE THE TABLE STRUCTURE
--##################################################################


--##################################################################
-- VALIDATE FOR EMAKG_Affiliations

ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [entity_id] INT;
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [class] VARCHAR(11);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [foaf_name] VARCHAR(120);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [foundation_date] smallint;
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [type_entities] VARCHAR(250);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [acronym] VARCHAR(10);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [city_name] VARCHAR(60);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [state_name] VARCHAR(60);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [postcode] VARCHAR(40);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [country_name] VARCHAR(40);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [country_alpha2] VARCHAR(5);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [country_alpha3] VARCHAR(5);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [country_official_name] VARCHAR(60);
ALTER TABLE [dbo].[EMAKG_Affiliations] ALTER COLUMN [country_2] VARCHAR(5);

exec sp_rename [EMAKG_Affiliations],[EMAKG_Affiliations_TT]

CREATE INDEX IDX_EMAKG_Affiliations_1 ON [dbo].[EMAKG_Affiliations]([entity_id]);


--##################################################################
--##################################################################
-- OPTIMIZING THE TABLES FOR LOGICAL EXECUTION 
--##################################################################
--##################################################################


--##################################################################
-- VALIDATE FOR EMAKG_Authors_disambiguated

CREATE table [dbo].[EMAKG_Authors_disambiguated_1] 
(
[entity_id]	bigint, 
[class]	varchar(6),
[rank]	varchar(5),
[org_memberOf]	varchar(10),
[foaf_name]		varchar(700),
[paperCount]		int,
[paperFamilyCount]		int,
[citationCount]		int
)


INSERT INTO [dbo].[EMAKG_Authors_disambiguated_1] 
SELECT 
cast([entity_id] as 	bigint), 
[class]	,
[rank]	,
[org#memberOf]	,
[foaf_name]		,
cast([paperCount]	as 	int),
cast([paperFamilyCount]	as	int),
cast([citationCount]	as	int)
from [dbo].[EMAKG_Authors_disambiguated] 


drop table [dbo].[EMAKG_Authors_disambiguated] 

exec sp_rename [EMAKG_Authors_disambiguated_1],[EMAKG_Authors_disambiguated]
CREATE INDEX IDX_Authors_disambiguated_1 ON [dbo].[EMAKG_Authors_disambiguated]([entity_id]);

exec sp_rename EMAKG_Authors_disambiguated,EMAKG_Authors_disambiguated_TT

UPDATE [dbo].[EMAKG_Authors_disambiguated_TT] SET [org_memberOf] = NULL WHERE [org_memberOf] = 'NULL'
ALTER TABLE [dbo].[EMAKG_Authors_disambiguated_TT] ALTER COLUMN [org_memberOf] BIGINT;
CREATE INDEX IDX_Authors_disambiguated_2 ON [dbo].[EMAKG_Authors_disambiguated_TT]([org_memberOf]);


--##################################################################
-- VALIDATE FOR [EMAKG_Papers]


CREATE table [dbo].[EMAKG_Papers_TT] 
(
[entity_id]						bigint,
[class]                         VARCHAR(5),
[entity_type]                   VARCHAR(20),
[appearsInJournal]              bigint,
[rank]                          int,
[estimatedCitationCount]        int,
[referenceCount]                int,
[familyId]                      bigint,
[citationCount]                 int,
[dcterms_created]               date,
[dcterms_title]                 VARCHAR(max),
[dcterms_publisher]             VARCHAR(max),
[dbo_publisher]                 VARCHAR(60)
)


select TOP 1000 * from [dbo].[EMAKG_Papers_TT]

INSERT INTO [dbo].[EMAKG_Papers_TT]
SELECT 
cast([entity_id] as 	bigint),
( CASE WHEN [class] = 'NULL' THEN NULL ELSE [class]  END ) ,
( CASE WHEN [entity_type] = 'NULL' THEN NULL ELSE [entity_type]  END ) ,
cast(( CASE WHEN [appearsInJournal] = 'NULL' THEN NULL ELSE [appearsInJournal]  END ) as bigint),
cast(( CASE WHEN [rank] = 'NULL' THEN NULL ELSE [rank]  END ) as int),
cast(( CASE WHEN [estimatedCitationCount] = 'NULL' THEN NULL ELSE [estimatedCitationCount]  END ) as int),
cast(( CASE WHEN [referenceCount] = 'NULL' THEN NULL ELSE [referenceCount]  END ) as int),
cast(( CASE WHEN [familyId] = 'NULL' THEN NULL ELSE [familyId]  END ) as bigint),
cast(( CASE WHEN [citationCount] = 'NULL' THEN NULL ELSE [citationCount]  END ) as int),
cast(( CASE WHEN [dcterms_created] = 'NULL' THEN NULL ELSE [dcterms_created]  END ) as date),
( CASE WHEN [dcterms_title] = 'NULL' THEN NULL ELSE [dcterms_title]  END ) ,
( CASE WHEN [dcterms_publisher] = 'NULL' THEN NULL ELSE [dcterms_publisher]  END ) ,
( CASE WHEN [dbo_publisher] = 'NULL' THEN NULL ELSE [dbo_publisher]  END ) 
from [dbo].[EMAKG_Papers_09]

[EMAKG_Papers_01] : (23866924 rows affected)
[EMAKG_Papers_02] : (23857487 rows affected)
[EMAKG_Papers_03] : (23870873 rows affected)
[EMAKG_Papers_04] : (23868481 rows affected)
[EMAKG_Papers_05] : (23865253 rows affected)
[EMAKG_Papers_06] : (23865566 rows affected)
[EMAKG_Papers_07] : (23871884 rows affected)
[EMAKG_Papers_08] : (23869413 rows affected)
[EMAKG_Papers_09] : (23869058 rows affected)
[EMAKG_Papers_00] : (23865961 rows affected)


commit

CREATE INDEX IDX_EMAKG_Papers_TT_1 ON [dbo].[EMAKG_Papers_TT]([entity_id]);

drop table [dbo].[EMAKG_Papers_09]





--##################################################################
-- VALIDATE FOR [EMAKG_PaperFieldsOfStudy_TT]
--##################################################################


EXEC sp_help 'dbo.[EMAKG_PaperFieldsOfStudy_0]';  

CREATE table [dbo].[EMAKG_PaperFieldsOfStudy_TT]
(
[entity_id]						bigint,
[fabio_hasDiscipline]           bigint
);


INSERT INTO [dbo].[EMAKG_PaperFieldsOfStudy_TT]
SELECT 
cast(( CASE WHEN [entity_id] = 'NULL' THEN NULL ELSE [entity_id]  END ) as bigint),
cast(( CASE WHEN [fabio_hasDiscipline] = 'NULL' THEN NULL ELSE [fabio_hasDiscipline]  END ) as bigint)
from [dbo].[EMAKG_PaperFieldsOfStudy_3];

[EMAKG_PaperFieldsOfStudy_0] : (141757790 rows affected)
[EMAKG_PaperFieldsOfStudy_1] : (141718599 rows affected)
[EMAKG_PaperFieldsOfStudy_2] : (141689371 rows affected)
[EMAKG_PaperFieldsOfStudy_3] : (141722324 rows affected)

select count(*) from [dbo].[EMAKG_PaperFieldsOfStudy_TT]

CREATE INDEX IDX_PaperFieldsOfStudy_TT_1 ON [dbo].[EMAKG_PaperFieldsOfStudy_TT]([entity_id]);
CREATE INDEX IDX_PaperFieldsOfStudy_TT_2 ON [dbo].[EMAKG_PaperFieldsOfStudy_TT]([fabio_hasDiscipline]);

drop table [dbo].[EMAKG_PaperFieldsOfStudy_0]

exec sp_rename [EMAKG_PaperFieldsOfStudy_TT],[EMAKG_PaperFieldsOfStudy_0123]


--##################################################################
-- VALIDATE FOR [EMAKG_PaperAuthorAffiliation]
--##################################################################


SELECT TOP (1000) [paper]
      ,[author]
      ,[affiliation1]
      ,[affiliation2]
  FROM [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation]
  where [affiliation2] = 'NULL'

/****** Updating Null Values in Table  ******/
update [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation] 
set [affiliation2] = NULL WHERE [affiliation2] = ''
(75509854 rows affected)

Total Records : 77396659

EXEC sp_help 'dbo.[EMAKG_PaperAuthorAffiliation]';  

SELECT count(*)
  FROM [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation]


/****** Analyse the data  ******/
    select 
   Top 1000 * 
   from 
 [patentview_trial].[dbo].[EMAKG_Papers]
 where len([dcterms_publisher])	> 1000

/****** CREATE THE TABLE  ******/
CREATE table [dbo].[EMAKG_PaperAuthorAffiliation_TT] 
(
[paper]						bigint,
[author]                    bigint,
[affiliation1]              bigint,
[affiliation2]              bigint
)


/****** INSERT THE TABLE  ******/

INSERT INTO [dbo].[EMAKG_PaperAuthorAffiliation_TT] 
SELECT 
cast([paper] as 	bigint),
cast([author] as 	bigint),
cast([affiliation1] as 	bigint),
cast([affiliation2] as 	bigint) 
from [dbo].[EMAKG_PaperAuthorAffiliation]

commit

CREATE INDEX IDX_EMAKG_PaperAuthorAffiliation_TT_1 ON [dbo].[EMAKG_PaperAuthorAffiliation_TT]([paper]);
CREATE INDEX IDX_EMAKG_PaperAuthorAffiliation_TT_2 ON [dbo].[EMAKG_PaperAuthorAffiliation_TT]([author]);
CREATE INDEX IDX_EMAKG_PaperAuthorAffiliation_TT_3 ON [dbo].[EMAKG_PaperAuthorAffiliation_TT]([affiliation1]);
CREATE INDEX IDX_EMAKG_PaperAuthorAffiliation_TT_4 ON [dbo].[EMAKG_PaperAuthorAffiliation_TT]([affiliation2]);

--drop table [dbo].[EMAKG_PaperAuthorAffiliation]


--##################################################################
-- VALIDATE FOR [EMAKG_ConferenceSeries]
--##################################################################


ALTER TABLE [dbo].[EMAKG_ConferenceSeries] ALTER COLUMN [entity_id] bigint;
exec sp_rename [EMAKG_ConferenceSeries],[EMAKG_ConferenceSeries_TT]
CREATE INDEX IDX_EMAKG_ConferenceSeries_1 ON [dbo].[EMAKG_ConferenceSeries_TT]([entity_id]);
 




--##################################################################
-- VALIDATE FOR [EMAKG_ConferenceInstances]
--##################################################################


ALTER TABLE [dbo].[EMAKG_ConferenceInstances] ALTER COLUMN [isPartOf] bigint;
CREATE INDEX IDX_EMAKG_ConferenceInstances_1 ON [dbo].[EMAKG_ConferenceInstances]([isPartOf]);
CREATE INDEX IDX_EMAKG_ConferenceInstances_2 ON [dbo].[EMAKG_ConferenceInstances_TT]([entity_id]);
 
exec sp_rename [EMAKG_ConferenceInstances],[EMAKG_ConferenceInstances_TT]


--##################################################################
-- VALIDATE FOR [EMAKG_FieldOfStudyChildren]
--##################################################################

SELECT TOP (1000) [entity_id]
      ,[hasParent]
  FROM [patentview_trial].[dbo].[EMAKG_FieldOfStudyChildren]
  where [entity_id] IS NULL 
  or [hasParent] IS NULL 

-- Both Columns are already big int

CREATE INDEX IDX_EMAKG_FieldOfStudyChildren_1 ON [dbo].[EMAKG_FieldOfStudyChildren]([entity_id]);
CREATE INDEX IDX_EMAKG_FieldOfStudyChildren_2 ON [dbo].[EMAKG_FieldOfStudyChildren]([hasParent]);

exec sp_rename [EMAKG_FieldOfStudyChildren],[EMAKG_FieldOfStudyChildren_TT]


--##################################################################
-- VALIDATE FOR [EMAKG_FieldOfStudyExtendedAttributes]
--##################################################################

SELECT TOP (1000) [entity_id]
      ,[owl_sameAs]
      ,[seeAlso]
  FROM [patentview_trial].[dbo].[EMAKG_FieldOfStudyExtendedAttributes]
  where [owl_sameAs] = 'NULL'


  update [patentview_trial].[dbo].[EMAKG_FieldOfStudyExtendedAttributes] set [owl_sameAs] = NULL WHERE [owl_sameAs] = 'NULL'
    update [patentview_trial].[dbo].[EMAKG_FieldOfStudyExtendedAttributes] set [seeAlso] = NULL WHERE [seeAlso] = 'NULL'

CREATE INDEX IDX_EMAKG_FieldOfStudyExtendedAttributes_1 ON [dbo].[EMAKG_FieldOfStudyExtendedAttributes]([entity_id]);
exec sp_rename [EMAKG_FieldOfStudyExtendedAttributes],[EMAKG_FieldOfStudyExtendedAttributes_TT]



--##################################################################
-- VALIDATE FOR [EMAKG_FieldOfStudyLabeled]
--##################################################################

SELECT TOP (1000) [entity_id]
      ,[fos_list]
  FROM [patentview_trial].[dbo].[EMAKG_FieldOfStudyLabeled]
  where [entity_id] IS NULL or [fos_list] IS NULL
  or [entity_id] = 'NULL' or [fos_list] = 'NULL'

ALTER TABLE [dbo].[EMAKG_FieldOfStudyLabeled] ALTER COLUMN [entity_id] bigint;

CREATE INDEX IDX_EMAKG_FieldOfStudyLabeled_1 ON [dbo].[EMAKG_FieldOfStudyLabeled]([entity_id]);
exec sp_rename [EMAKG_FieldOfStudyLabeled],[EMAKG_FieldOfStudyLabeled_TT]


SELECT count(*) 
  FROM [patentview_trial].[dbo].[EMAKG_FieldOfStudyLabeled]
740460


SELECT count(*) 
  FROM [dbo].[EMAKG_FieldsOfStudy]
740460



--##################################################################
-- VALIDATE FOR [EMAKG_FieldsOfStudy]
--##################################################################

SELECT TOP (1000) [entity_id]
      ,[class]
      ,[foaf_name]
      ,[rank]
      ,[level]
      ,[paperFamilyCount]
      ,[citationCount]
      ,[paperCount]
  FROM [patentview_trial].[dbo].[EMAKG_FieldsOfStudy]
  where entity_id is null or entity_id = 'NULL'

  ALTER TABLE [dbo].[EMAKG_FieldsOfStudy] ALTER COLUMN [entity_id] bigint;

CREATE INDEX IDX_EMAKG_FieldsOfStudy_1 ON [dbo].[EMAKG_FieldsOfStudy]([entity_id]);
exec sp_rename [EMAKG_FieldsOfStudy],[EMAKG_FieldsOfStudy_TT]

--##################################################################
-- VALIDATE FOR [EMAKG_PaperAuthorAffiliation_large]
--##################################################################



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [entity_id]
      ,[dcterms_creator]
  FROM [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation_large]
  where [entity_id] is null or [dcterms_creator] is null 
  or [entity_id] = 'NULL' or [dcterms_creator]  = 'NULL'

 create table [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] 
 (
 [entity_id]	bigint,
 [dcterms_creator]	bigint
 )

 INSERT INTO [dbo].[EMAKG_PaperAuthorAffiliation_large_TT]
 select 
 cast([entity_id] as 	bigint),
 cast([dcterms_creator] as 	bigint)
 from [dbo].[EMAKG_PaperAuthorAffiliation_large]

 CREATE INDEX IDX_EMAKG_PaperAuthorAffiliation_large_TT_1 ON [dbo].[EMAKG_PaperAuthorAffiliation_large_TT]([entity_id]);
 CREATE INDEX IDX_EMAKG_PaperAuthorAffiliation_large_TT_2 ON [dbo].[EMAKG_PaperAuthorAffiliation_large_TT]([dcterms_creator]);


 SELECT count(*) from [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation_large_TT]
 638211906
 SELECT count(*) from [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation_large]
 638211906

 -- DROP TABLE [patentview_trial].[dbo].[EMAKG_PaperAuthorAffiliation_large]





--##################################################################
-- VALIDATE FOR USPTO_g_inventor_disambiguated_TT
--##################################################################

  SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_inventor_disambiguated]
  where [disambig_inventor_name_first] = 'NULL'

    SELECT MAX(LEN(patent_id))
  FROM [patentview_trial].[dbo].[g_inventor_disambiguated]
  where [disambig_inventor_name_first] = 'NULL'


CREATE TABLE [dbo].[USPTO_g_inventor_disambiguated_TT]
(
patent_id						       VARCHAR(12),
inventor_sequence                      SMALLINT,
inventor_id                            VARCHAR(80),
disambig_inventor_name_first           VARCHAR(80),
disambig_inventor_name_last            VARCHAR(80),
male_flag                              TINYINT,
attribution_status                     TINYINT,
location_id                            VARCHAR(40)
);

INSERT INTO [dbo].[USPTO_g_inventor_disambiguated_TT]
SELECT
( CASE WHEN patent_id = 'NULL' THEN NULL ELSE patent_id  END ) ,
cast(inventor_sequence as 	SMALLINT),
( CASE WHEN inventor_id = 'NULL' THEN NULL ELSE inventor_id  END ) ,
( CASE WHEN disambig_inventor_name_first = 'NULL' THEN NULL ELSE disambig_inventor_name_first  END ) ,
( CASE WHEN disambig_inventor_name_last = 'NULL' THEN NULL ELSE disambig_inventor_name_last  END ) ,
cast(male_flag as 	tinyint),
cast(attribution_status as 	tinyint),
( CASE WHEN location_id = 'NULL' THEN NULL ELSE location_id  END ) 
FROM [dbo].[g_inventor_disambiguated]

COMMIT

CREATE INDEX IDX_USPTO_g_inventor_disambiguated_TT_1 ON [dbo].[USPTO_g_inventor_disambiguated_TT](patent_id);
CREATE INDEX IDX_USPTO_g_inventor_disambiguated_TT_2 ON [dbo].[USPTO_g_inventor_disambiguated_TT](location_id);
CREATE INDEX IDX_USPTO_g_inventor_disambiguated_TT_3 ON [dbo].[USPTO_g_inventor_disambiguated_TT](patent_id,inventor_sequence);
CREATE INDEX IDX_USPTO_g_inventor_disambiguated_TT_4 ON [dbo].[USPTO_g_inventor_disambiguated_TT]([inventor_id]);

select TOP 100 * from 
[dbo].[USPTO_g_inventor_disambiguated_TT]

drop table   [dbo].[g_inventor_disambiguated]


--##################################################################
-- VALIDATE FOR [USPTO_g_assignee_disambiguated]
--##################################################################

/****** Script for SelectTopNRows command from SSMS  ******/
    SELECT count(*)
  FROM [patentview_trial].[dbo].[USPTO_g_assignee_disambiguated]

    SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[USPTO_g_assignee_disambiguated]
  where [disambig_inventor_name_first] = 'NULL'
  
  SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[USPTO_g_assignee_disambiguated]
  where LEN(location_id) = 36

    SELECT MAX(LEN(location_id))
  FROM [patentview_trial].[dbo].[USPTO_g_assignee_disambiguated]
  where [disambig_inventor_name_first] = 'NULL'

CREATE TABLE [dbo].[USPTO_g_assignee_disambiguated_TT]
(
patent_id						       VARCHAR(8),
assignee_sequence                      tinyint,
assignee_id                            VARCHAR(40),
disambig_assignee_individual_name_first           VARCHAR(80),
disambig_assignee_individual_name_last            VARCHAR(80),
disambig_assignee_organization                              VARCHAR(250),
assignee_type                     float,
location_id                            VARCHAR(40)
);

INSERT INTO [dbo].[USPTO_g_assignee_disambiguated_TT]
SELECT 
( CASE WHEN patent_id = 'NULL' THEN NULL ELSE patent_id  END ) ,
cast(assignee_sequence as 	tinyint),
( CASE WHEN assignee_id = 'NULL' THEN NULL ELSE assignee_id  END ) ,
( CASE WHEN disambig_assignee_individual_name_first = 'NULL' THEN NULL ELSE disambig_assignee_individual_name_first  END ) ,
( CASE WHEN disambig_assignee_individual_name_last = 'NULL' THEN NULL ELSE disambig_assignee_individual_name_last  END ) ,
( CASE WHEN disambig_assignee_organization = 'NULL' THEN NULL ELSE disambig_assignee_organization  END ) ,
cast(assignee_type as 	float),
( CASE WHEN location_id = 'NULL' THEN NULL ELSE location_id  END ) 
FROM [dbo].[USPTO_g_assignee_disambiguated]

CREATE INDEX IDX_USPTO_g_assignee_disambiguated_TT_1 ON [dbo].[USPTO_g_assignee_disambiguated_TT](patent_id);
CREATE INDEX IDX_USPTO_g_assignee_disambiguated_TT_2 ON [dbo].[USPTO_g_assignee_disambiguated_TT](location_id);
CREATE INDEX IDX_USPTO_g_assignee_disambiguated_TT_3 ON [dbo].[USPTO_g_assignee_disambiguated_TT](patent_id,assignee_sequence);
CREATE INDEX IDX_USPTO_g_assignee_disambiguated_TT_4 ON [dbo].[USPTO_g_assignee_disambiguated_TT](assignee_id);



select count(*) from [dbo].[USPTO_g_assignee_disambiguated]
7596786
select count(*) from [dbo].[USPTO_g_assignee_disambiguated_TT]
7596786

--drop table [dbo].[USPTO_g_assignee_disambiguated]

--##################################################################
-- VALIDATE FOR [g_location_disambiguated]
--##################################################################


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [column1]

  FROM [patentview_trial].[dbo].[g_location_disambiguated]


    SELECT count(*)
  FROM [patentview_trial].[dbo].[g_location_disambiguated]

    SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_location_disambiguated]
  where [disambig_inventor_name_first] = 'NULL'
  
  SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_location_disambiguated]
  where LEN([state_fips]) = 4

    SELECT MAX(LEN([county_fips]))
  FROM [patentview_trial].[dbo].[g_location_disambiguated]
  where [disambig_inventor_name_first] = 'NULL'


CREATE TABLE [dbo].[USPTO_g_location_disambiguated_TT]
(
[location_id]						       VARCHAR(40),
[disambig_city]                      VARCHAR(50),
[disambig_state]                            VARCHAR(5),
[disambig_country]           VARCHAR(5),
[latitude]            FLOAT,
[longitude]                              FLOAT,
[county]                     VARCHAR(30),
[state_fips]                           FLOAT,
[county_fips]			FLOAT
);

insert into [dbo].[USPTO_g_location_disambiguated_TT]
SELECT 
( CASE WHEN [location_id] = 'NULL' THEN NULL ELSE [location_id]  END ) ,
( CASE WHEN [disambig_city] = 'NULL' THEN NULL ELSE [disambig_city]  END ) ,
( CASE WHEN [disambig_state] = 'NULL' THEN NULL ELSE [disambig_state]  END ) ,
( CASE WHEN [disambig_country] = 'NULL' THEN NULL ELSE [disambig_country]  END ) ,
cast([latitude] as 	float),
cast([longitude] as 	float),
( CASE WHEN [county] = 'NULL' THEN NULL ELSE [county]  END ) ,
cast([state_fips] as 	float),
cast([county_fips] as 	float)
FROM [dbo].[g_location_disambiguated]

CREATE INDEX IDX_USPTO_g_location_disambiguated_TT_1 ON [dbo].[USPTO_g_location_disambiguated_TT]([location_id]);




select count(*) from [dbo].g_location_disambiguated
81837
select count(*) from [dbo].[USPTO_g_location_disambiguated_TT]
81837

drop table [dbo].g_location_disambiguated

--##################################################################
-- VALIDATE FOR [USPTO_g_patent]
--##################################################################

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [patent_id]
      ,[patent_type]
      ,[patent_date]
      ,[patent_title]
      ,[patent_abstract]
      ,[wipo_kind]
      ,[num_claims]
      ,[withdrawn]
      ,[filename]
  FROM [patentview_trial].[dbo].[USPTO_g_patent]


  
    SELECT count(*)
  FROM [patentview_trial].[dbo].[USPTO_g_patent]

    SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[USPTO_g_patent]
  where [disambig_inventor_name_first] = 'NULL'
  
  SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[USPTO_g_patent]
  where LEN([state_fips]) = 4

    SELECT MAX(LEN([filename]))
  FROM [patentview_trial].[dbo].[USPTO_g_patent]
  where [disambig_inventor_name_first] = 'NULL'


CREATE TABLE [dbo].[USPTO_g_patent_TT]
(
[patent_id]			VARCHAR(10),
[patent_type]		VARCHAR(10),
[patent_date]		DATE,
[patent_title]		VARCHAR(700),
[patent_abstract]	VARCHAR(MAX),
[wipo_kind]			VARCHAR(2),
[num_claims]		smallint,
[withdrawn]			tinyint,
[filename]			VARCHAR(30)
);

insert into [dbo].[USPTO_g_patent_TT]
SELECT 
( CASE WHEN [patent_id] = 'NULL' THEN NULL ELSE [patent_id]  END ) ,
( CASE WHEN [patent_type] = 'NULL' THEN NULL ELSE [patent_type]  END ) ,
cast([patent_date] as 	date),
( CASE WHEN [patent_title] = 'NULL' THEN NULL ELSE [patent_title]  END ) ,
( CASE WHEN [patent_abstract] = 'NULL' THEN NULL ELSE [patent_abstract]  END ) ,
( CASE WHEN [wipo_kind] = 'NULL' THEN NULL ELSE [wipo_kind]  END ) ,
cast([num_claims] as 	smallint),
cast([withdrawn] as 	tinyint),
( CASE WHEN [filename] = 'NULL' THEN NULL ELSE [filename]  END ) 
FROM [dbo].[USPTO_g_patent]


CREATE INDEX IDX_USPTO_g_patent_TT_1 ON [dbo].[USPTO_g_patent_TT]([patent_id]);

select count(*) from [dbo].[USPTO_g_patent]
5008469
select count(*) from [dbo].[USPTO_g_patent_TT]
5008469

drop table [dbo].[USPTO_g_patent]

--##################################################################
-- VALIDATE FOR [g_application]
--##################################################################
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [column1]
      ,[application_id]
      ,[patent_id]
      ,[patent_application_type]
      ,[filing_date]
      ,[series_code]
      ,[rule_47_flag]
  FROM [patentview_trial].[dbo].[g_application]

     SELECT count(*) FROM [patentview_trial].[dbo].[g_application]
	 8257883


    SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_application]
  where [series_code] = 'D'
  
  SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_application]
  where LEN([state_fips]) = 4

    SELECT MAX(LEN([patent_application_type]))
  FROM [patentview_trial].[dbo].[g_application]
  where [disambig_inventor_name_first] = 'NULL'

 
--DROP TABLE [dbo].[USPTO_g_application_TT];
CREATE TABLE [dbo].[USPTO_g_application_TT]
(
[application_id]			VARCHAR(15),
[patent_id]		VARCHAR(10),
[patent_application_type]		VARCHAR(2),
[filing_date]		DATE,
[series_code]	VARCHAR(2),
[rule_47_flag]			tinyint
);


INSERT INTO  [dbo].[USPTO_g_application_TT]
SELECT 
( CASE WHEN [application_id] = 'NULL' THEN NULL ELSE [application_id]  END ) ,
( CASE WHEN [patent_id] = 'NULL' THEN NULL ELSE [patent_id]  END ) ,
( CASE WHEN [patent_application_type] = 'NULL' THEN NULL ELSE [patent_application_type]  END ) ,
cast([filing_date] as 	date),
( CASE WHEN [series_code] = 'NULL' THEN NULL ELSE [series_code]  END ) ,
cast([rule_47_flag] as 	tinyint)
FROM [dbo].[g_application]

CREATE INDEX IDX_USPTO_g_application_TT_1 ON [dbo].[USPTO_g_application_TT]([patent_id]);
CREATE INDEX IDX_USPTO_g_application_TT_2 ON [dbo].[USPTO_g_application_TT]([application_id]);


select count(*) from [dbo].[g_application]
8257883
select count(*) from [dbo].[USPTO_g_application_TT]
8257883

--drop table [dbo].[g_application]



--##################################################################
-- VALIDATE FOR [g_cpc_title]
--##################################################################



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [column1]
      ,[cpc_subclass]
      ,[cpc_subclass_title]
      ,[cpc_group]
      ,[cpc_group_title]
      ,[cpc_class]
      ,[cpc_class_title]
  FROM [patentview_trial].[dbo].[g_cpc_title]


       SELECT count(*) FROM [patentview_trial].[dbo].[g_cpc_title]
	 8257883

    SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_cpc_title]
  where [series_code] = 'D'
  
  SELECT TOP (1000) *
  FROM [patentview_trial].[dbo].[g_cpc_title]
  where LEN([state_fips]) = 4

    SELECT MAX(LEN([cpc_class_title]))
  FROM [patentview_trial].[dbo].[g_cpc_title]
  where [disambig_inventor_name_first] = 'NULL'

ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] DROP COLUMN [column1];

ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] ALTER COLUMN [cpc_subclass]  VARCHAR(4);
ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] ALTER COLUMN [cpc_subclass_title]  VARCHAR(450);
ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] ALTER COLUMN [cpc_group]  VARCHAR(15);
ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] ALTER COLUMN [cpc_group_title]  VARCHAR(1450);
ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] ALTER COLUMN [cpc_class]  VARCHAR(5);
ALTER TABLE [patentview_trial].[dbo].[g_cpc_title] ALTER COLUMN [cpc_class_title]  VARCHAR(350);

CREATE INDEX IDX_g_cpc_title_1 ON [dbo].[g_cpc_title]([cpc_subclass]);
CREATE INDEX IDX_g_cpc_title_2 ON [dbo].[g_cpc_title]([cpc_group]);
CREATE INDEX IDX_g_cpc_title_3 ON [dbo].[g_cpc_title]([cpc_class]);

commit
exec sp_rename [g_cpc_title],[USPTO_g_cpc_title_TT]



--##################################################################
-- VALIDATE FOR [g_foreign_priority]
--##################################################################


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [column1]
      ,[patent_id]
      ,[priority_claim_sequence]
      ,[priority_claim_kind]
      ,[foreign_application_id]
      ,[filing_date]
      ,[foreign_country_filed]
  FROM [patentview_trial].[dbo].[g_foreign_priority]




 SELECT MAX(LEN([foreign_country_filed]))
  FROM [patentview_trial].[dbo].[g_foreign_priority]
  where [cpc_symbol_position] IS NOT NULL 


CREATE TABLE [dbo].[USPTO_g_foreign_priority_TT]
(
[patent_id]					    VARCHAR(8),
[priority_claim_sequence]       TINYINT,
[priority_claim_kind]           VARCHAR(15),
[foreign_application_id]        VARCHAR(30),
[filing_date]                   DATE,
[foreign_country_filed]         VARCHAR(2)
);

INSERT INTO [dbo].[USPTO_g_foreign_priority_TT]
SELECT 
( CASE WHEN [patent_id] = 'NULL' THEN NULL ELSE [patent_id]  END ) ,
cast([priority_claim_sequence] as 	tinyint),
( CASE WHEN [priority_claim_kind] = 'NULL' THEN NULL ELSE [priority_claim_kind]  END ) ,
( CASE WHEN [foreign_application_id] = 'NULL' THEN NULL ELSE [foreign_application_id]  END ) ,
cast([filing_date] as 	date),
( CASE WHEN [foreign_country_filed] = 'NULL' THEN NULL ELSE [foreign_country_filed]  END )
FROM [dbo].[g_foreign_priority]


CREATE INDEX IDX_USPTO_g_foreign_priority_TT_1 ON [dbo].[USPTO_g_foreign_priority_TT]([patent_id]);

 SELECT count(*) FROM [patentview_trial].[dbo].[g_foreign_priority]
 3827627
 SELECT count(*) FROM [patentview_trial].[dbo].[USPTO_g_foreign_priority_TT]
 3827627


 drop table [dbo].[g_foreign_priority]


--##################################################################
-- VALIDATE FOR USPTO_g_foreign_priority_TT
--##################################################################


drop table [dbo].USPTO_g_foreign_priority


select * 
into [dbo].USPTO_g_foreign_priority_MAX_REC_TT
from 
(
select 
patent_id, priority_claim_sequence, priority_claim_kind,	foreign_application_id,	filing_date,	foreign_country_filed , 
ROW_NUMBER() OVER(PARTITION BY patent_id ORDER BY priority_claim_sequence DESC) AS rk
FROM 
[dbo].USPTO_g_foreign_priority_TT
)A1 where A1.rk = 1

(3079942 rows affected)

select TOP 100 * from USPTO_g_foreign_priority_MAX_REC_TT
CREATE INDEX IDX_USPTO_g_foreign_priority_MAX_REC_TT_1 ON [dbo].[USPTO_g_foreign_priority_MAX_REC_TT](patent_id);



--##################################################################
-- VALIDATE FOR [[USPTO_g_cpc_current_TT]]
--##################################################################


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [patent_id]
      ,[cpc_sequence]
      ,[cpc_section]
      ,[cpc_class]
      ,[cpc_subclass]
      ,[cpc_group]
      ,[cpc_type]
      ,[cpc_symbol_position]
  FROM [patentview_trial].[dbo].[USPTO_g_cpc_current]

       SELECT count(*) FROM [patentview_trial].[dbo].[USPTO_g_cpc_current]
	 48473812


     SELECT MAX(LEN([cpc_symbol_position]))
  FROM [patentview_trial].[dbo].[USPTO_g_cpc_current]
  where [cpc_symbol_position] IS NOT NULL 


CREATE TABLE [dbo].[USPTO_g_cpc_current_TT]
(
[patent_id]				VARCHAR(8),
[cpc_sequence]          SMALLINT,
[cpc_section]           VARCHAR(1),
[cpc_class]             VARCHAR(3),
[cpc_subclass]          VARCHAR(4),
[cpc_group]             VARCHAR(15),
[cpc_type]              VARCHAR(15)
);

INSERT INTO [dbo].[USPTO_g_cpc_current_TT]
SELECT 
( CASE WHEN [patent_id] = 'NULL' THEN NULL ELSE [patent_id]  END ) ,
cast([cpc_sequence] as 	SMALLINT),
( CASE WHEN [cpc_section] = 'NULL' THEN NULL ELSE [cpc_section]  END ) ,
( CASE WHEN [cpc_class] = 'NULL' THEN NULL ELSE [cpc_class]  END ) ,
( CASE WHEN [cpc_subclass] = 'NULL' THEN NULL ELSE [cpc_subclass]  END ) ,
( CASE WHEN [cpc_group] = 'NULL' THEN NULL ELSE [cpc_group]  END ) ,
( CASE WHEN [cpc_type] = 'NULL' THEN NULL ELSE [cpc_type]  END ) 
FROM [dbo].[USPTO_g_cpc_current]

CREATE INDEX IDX_USPTO_g_cpc_current_TT_1 ON [dbo].[USPTO_g_cpc_current_TT]([patent_id]);
CREATE INDEX IDX_USPTO_g_cpc_current_TT_2 ON [dbo].[USPTO_g_cpc_current_TT]([cpc_class]);
CREATE INDEX IDX_USPTO_g_cpc_current_TT_3 ON [dbo].[USPTO_g_cpc_current_TT]([cpc_subclass]);
CREATE INDEX IDX_USPTO_g_cpc_current_TT_4 ON [dbo].[USPTO_g_cpc_current_TT]([cpc_group]);


 SELECT count(*) FROM [patentview_trial].[dbo].[USPTO_g_cpc_current]
48473812
 SELECT count(*) FROM [patentview_trial].[dbo].[USPTO_g_cpc_current_TT]
 48473812

 --drop table [dbo].[USPTO_g_cpc_current]
 commit



--##################################################################
-- LOADING TABLE USPTO_g_foreign_citation
--##################################################################



create table dbo.USPTO_g_foreign_citation  
(
patent_id					VARCHAR(max) ,
citation_sequence           VARCHAR(max) ,
citation_application_id     VARCHAR(max) ,
citation_date               VARCHAR(max) ,
citation_category           VARCHAR(max) ,
citation_country            VARCHAR(max)
); 


Get-Content -Head 1 g_foreign_citation.csv


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [patent_id]
      ,[citation_sequence]
      ,[citation_application_id]
      ,[citation_date]
      ,[citation_category]
      ,[citation_country]
  FROM [patentview_trial].[dbo].[USPTO_g_foreign_citation]


SELECT count(*) FROM [patentview_trial].[dbo].[USPTO_g_foreign_citation]
	 35757764

SELECT MAX(LEN(citation_country))
  FROM [patentview_trial].[dbo].[USPTO_g_foreign_citation]
  where [cpc_symbol_position] IS NOT NULL 


SELECT TOP 100 * 
  FROM [patentview_trial].[dbo].[USPTO_g_foreign_citation]
  where LEN(citation_country) = 3;

create table dbo.USPTO_g_foreign_citation_TT 
(
patent_id					VARCHAR(8) ,
citation_sequence           SMALLINT ,
citation_application_id     VARCHAR(64) ,
citation_date               date ,
citation_category           VARCHAR(40) ,
citation_country            VARCHAR(3)
); 


INSERT INTO [dbo].USPTO_g_foreign_citation_TT
SELECT 
( CASE WHEN [patent_id] = 'NULL' THEN NULL ELSE [patent_id]  END ) ,
cast(citation_sequence as 	SMALLINT),
( CASE WHEN citation_application_id = 'NULL' THEN NULL ELSE citation_application_id  END ) ,
cast(citation_date as 	DATE),
( CASE WHEN citation_category = 'NULL' THEN NULL ELSE citation_category  END ) ,
( CASE WHEN citation_country = 'NULL' THEN NULL ELSE citation_country  END )
FROM [dbo].[USPTO_g_foreign_citation]



CREATE INDEX IDX_USPTO_g_foreign_citation_TT_1 ON [dbo].USPTO_g_foreign_citation_TT([patent_id]);
CREATE INDEX IDX_USPTO_g_foreign_citation_TT_2 ON [dbo].USPTO_g_foreign_citation_TT([patent_id],citation_sequence);



 SELECT count(*) FROM [patentview_trial].[dbo].[USPTO_g_foreign_citation]
35757764
 SELECT count(*) FROM [patentview_trial].[dbo].USPTO_g_foreign_citation_TT
 35757764

 --drop table [dbo].[USPTO_g_foreign_citation]
 commit;
 
