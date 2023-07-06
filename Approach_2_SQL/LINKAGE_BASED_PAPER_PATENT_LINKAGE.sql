
--##################################################################
-- SQL CODE FOR PAPER TO PATENT MATCHING
--##################################################################

select X.* , 
dbo.edit_distance(X.Author_Name_Corrected, X.Inventor_Name_Corrected) CORERECTED_NAME_DISTANCE,
dbo.edit_distance(X.Author_Name, X.Inventor_Name) ORIGINAL_NAME_DISTANCE
INTO [dbo].DERV_PAPER_PATENT_LINKAGE
from 
(
SELECT 
A.paper_id , A.patent_id, B.dcterms_creator, C.class, C.foaf_name as Author_Name, D.foaf_name AS Institution_Name, D.city_name, D.state_name, D.country_name, D.country_alpha2,
E.disambig_inventor_name_first, E.disambig_inventor_name_last, CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last) AS Inventor_Name,  E.inventor_id,
F.disambig_city Inventor_City, F.disambig_state Inventor_State,  F.disambig_country Inventor_Country,
dbo.Removespecialcharatersinstring(C.foaf_name) AS Author_Name_Corrected, 
dbo.Removespecialcharatersinstring(CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last)) AS Inventor_Name_Corrected
FROM dbo.EMAKG_Paper_Patent_Linkage_TT A
  INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] B ON A.paper_id  = B.entity_id
  INNER JOIN [dbo].[EMAKG_Authors_disambiguated_TT] C ON C.entity_id = B.dcterms_creator
  LEFT JOIN [dbo].[EMAKG_Affiliations_TT] D ON D.entity_id = C.org_memberOf
INNER JOIN [dbo].[USPTO_g_inventor_disambiguated_TT] E ON E.patent_id = A.patent_id
LEFT JOIN [dbo].[USPTO_g_location_disambiguated_TT] F ON F.location_id = E.location_id 
) AS X;


--##################################################################
-- SQL CODE TO CREATE THE TABLE 
--##################################################################


SELECT 
A.paper_id , A.patent_id, B.dcterms_creator, C.class, C.foaf_name as Author_Name, D.foaf_name AS Institution_Name, D.city_name, D.state_name, D.country_name, D.country_alpha2,
E.disambig_inventor_name_first, E.disambig_inventor_name_last, CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last) AS Inventor_Name,  E.inventor_id,
F.disambig_city Inventor_City, F.disambig_state Inventor_State,  F.disambig_country Inventor_Country
INTO [dbo].DERV_PAPER_PATENT_LINKAGE
FROM 
dbo.EMAKG_Paper_Patent_Linkage_TT A
  INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] B ON A.paper_id  = B.entity_id AND 1 = 0
  INNER JOIN [dbo].[EMAKG_Authors_disambiguated_TT] C ON C.entity_id = B.dcterms_creator 
  LEFT JOIN [dbo].[EMAKG_Affiliations_TT] D ON D.entity_id = C.org_memberOf
INNER JOIN [dbo].[USPTO_g_inventor_disambiguated_TT] E ON E.patent_id = A.patent_id
LEFT JOIN [dbo].[USPTO_g_location_disambiguated_TT] F ON F.location_id = E.location_id 


--##################################################################
-- SQL CODE TO INSERT THE RECORDS
--##################################################################


INSERT INTO [dbo].DERV_PAPER_PATENT_LINKAGE
SELECT 
A.paper_id , A.patent_id, B.dcterms_creator, C.class, C.foaf_name as Author_Name, D.foaf_name AS Institution_Name, D.city_name, D.state_name, D.country_name, D.country_alpha2,
E.disambig_inventor_name_first, E.disambig_inventor_name_last, CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last) AS Inventor_Name,  E.inventor_id,
F.disambig_city Inventor_City, F.disambig_state Inventor_State,  F.disambig_country Inventor_Country
FROM 
dbo.EMAKG_Paper_Patent_Linkage_TT A
  INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] B ON A.paper_id  = B.entity_id
  INNER JOIN [dbo].[EMAKG_Authors_disambiguated_TT] C ON C.entity_id = B.dcterms_creator 
  LEFT JOIN [dbo].[EMAKG_Affiliations_TT] D ON D.entity_id = C.org_memberOf
INNER JOIN [dbo].[USPTO_g_inventor_disambiguated_TT] E ON E.patent_id = A.patent_id
LEFT JOIN [dbo].[USPTO_g_location_disambiguated_TT] F ON F.location_id = E.location_id;

--##################################################################
-- SQL CODE TO INSERT THE CLEAN RECORDS FOR AUTHOR AND INVENTOR NAME
--##################################################################

ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE ADD Author_Name_Corrected VARCHAR(700);
ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE ADD Inventor_Name_Corrected VARCHAR(200);

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Author_Name_Corrected = UPPER(Author_Name);
UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Author_Name_Corrected = UPPER(Author_Name_Corrected);

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Inventor_Name_Corrected = UPPER(Inventor_Name) ;

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Author_Name_Corrected = dbo.Removespecialcharatersinstring(Author_Name_Corrected);
UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Inventor_Name_Corrected = dbo.Removespecialcharatersinstring(Inventor_Name_Corrected);

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Author_Name_Corrected = REPLACE(Author_Name_Corrected,'  ',' ');
UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Author_Name_Corrected = REPLACE(Author_Name_Corrected,'  ',' ');
UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Author_Name_Corrected = REPLACE(Author_Name_Corrected,'  ',' ') where Author_Name_Corrected LIKE '%  %';

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Inventor_Name_Corrected = REPLACE(Inventor_Name_Corrected,'  ',' ') where Inventor_Name_Corrected LIKE '%  %';
UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Inventor_Name_Corrected = REPLACE(Inventor_Name_Corrected,'  ',' ') where Inventor_Name_Corrected LIKE '%  %';
UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE  SET Inventor_Name_Corrected = REPLACE(Inventor_Name_Corrected,'  ',' ') where Inventor_Name_Corrected LIKE '%  %';


--##################################################################
-- SQL CODE TO UPDATE DISTANCE BETWEEN AUTHOR AND INVENTOR NAME
--##################################################################

-- CREATING TABLE FOR DISTANCE
select TOP 100 ROW_NUMBER() OVER(ORDER BY paper_id DESC) REC_ID, *
INTO [dbo].DERV_PAPER_PATENT_LINKAGE_1
FROM
[dbo].DERV_PAPER_PATENT_LINKAGE where 1=2;

-- INSERTING INTO TABLE FOR DISTANCE
INSERT INTO [dbo].DERV_PAPER_PATENT_LINKAGE_1
select ROW_NUMBER() OVER(ORDER BY paper_id DESC) REC_ID, *
FROM
[dbo].DERV_PAPER_PATENT_LINKAGE;

ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE_1 ADD CORRECTED_NAME_DISTANCE INTEGER;
ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE_1 ADD ORIGINAL_NAME_DISTANCE INTEGER;

-- UPDATING EDIT DISTANCE IN AUTHOR AND INVENTOR NAME
DECLARE @RowCnt INT;
DECLARE @REC_ID INT = 1;
 
SELECT @RowCnt = COUNT(*) FROM [dbo].DERV_PAPER_PATENT_LINKAGE_1;
 
WHILE @REC_ID <= @RowCnt
BEGIN
	UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE_1 
	SET 
	CORRECTED_NAME_DISTANCE = dbo.edit_distance(Author_Name_Corrected, Inventor_Name_Corrected),
	ORIGINAL_NAME_DISTANCE = dbo.edit_distance(Author_Name,Inventor_Name)
	WHERE REC_ID BETWEEN 1 AND @REC_ID
	AND CORRECTED_NAME_DISTANCE IS NULL;
	
   SET @REC_ID += 100000
END
GO

-- UPDATING EDIT DISTANCE FOR PENDING RECORDS
SELECT count(*) FROM [dbo].DERV_PAPER_PATENT_LINKAGE_1 WITH (NOLOCK) where CORRECTED_NAME_DISTANCE IS NULL 

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE_1 
	SET 
	CORRECTED_NAME_DISTANCE = dbo.edit_distance(Author_Name_Corrected, Inventor_Name_Corrected),
	ORIGINAL_NAME_DISTANCE = dbo.edit_distance(Author_Name,Inventor_Name)
	WHERE CORRECTED_NAME_DISTANCE IS NULL;

-- RENAMING THE TABLE 
DROP TABLE [dbo].DERV_PAPER_PATENT_LINKAGE;
exec sp_rename DERV_PAPER_PATENT_LINKAGE_1,DERV_PAPER_PATENT_LINKAGE;

--##################################################################
-- CHECK THE STATUS POST EDIT DISTANCE VALIDATION
--##################################################################

-- CHECK IF CORRECTED NAME DISTANCE MORE THAN ORIGINAL NAME DISTANCE

SELECT count(*) FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
where CORRECTED_NAME_DISTANCE > ORIGINAL_NAME_DISTANCE

-- Only for 281 Records



-- CHECK DISTRIBUTION OF DATA FROM CORRECTED NAME DISTANCE

SELECT CORRECTED_NAME_DISTANCE, count(*) FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
GROUP BY CORRECTED_NAME_DISTANCE
ORDER BY CORRECTED_NAME_DISTANCE

-- Based on Review of the data, only items with CORRECTED_NAME_DISTANCE <= 2 Can be immediately allowed

SELECT count(*) FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
WHERE CORRECTED_NAME_DISTANCE BETWEEN 3 AND 10
--5750913



--##################################################################
-- PUSH RECORDS INTO ANOTHER TABLE 
--##################################################################

SELECT distinct 
REC_ID,paper_id,patent_id,dcterms_creator,inventor_id,Author_Name_Corrected,Inventor_Name_Corrected,CORRECTED_NAME_DISTANCE,ORIGINAL_NAME_DISTANCE
INTO [dbo].DERV_PAPER_PATENT_LINKAGE_DISTINCT
FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WHERE CORRECTED_NAME_DISTANCE BETWEEN 3 AND 10

-- (5750913 rows affected)



SELECT TOP 100 
REC_ID,paper_id,patent_id,dcterms_creator,inventor_id,Author_Name_Corrected,Inventor_Name_Corrected,CORRECTED_NAME_DISTANCE,ORIGINAL_NAME_DISTANCE
FROM [dbo].DERV_PAPER_PATENT_LINKAGE_DISTINCT



--##################################################################
-- FETCHING THE DATA FRAME INTO TABLE POST SIMILARITY COMPARISON
--##################################################################

CREATE TABLE [dbo].DERV_PAPER_PATENT_LINKAGE_SIMILARITY
(
REC_ID						 INTEGER,
paper_id                     VARCHAR(100),
patent_id                    VARCHAR(100),
dcterms_creator              VARCHAR(100),
inventor_id                  VARCHAR(100),
Author_Name_Corrected        VARCHAR(100),
Inventor_Name_Corrected      VARCHAR(100),
CORRECTED_NAME_DISTANCE      VARCHAR(100),
ORIGINAL_NAME_DISTANCE       VARCHAR(100),
similarity_score_50          SMALLINT,
similarity_score_60          SMALLINT,
similarity_score_70          SMALLINT,
similarity_score_80          SMALLINT,
similarity_score_90          SMALLINT,
similarity_score_95          SMALLINT,
token_jaccard_similarity     FLOAT
);




select count(*) FROM  [dbo].DERV_PAPER_PATENT_LINKAGE_SIMILARITY WITH (NOLOCK)
5750913

SELECT ROUND(token_jaccard_similarity,2) SIMILARITY,  COUNT(*)
FROM  [dbo].DERV_PAPER_PATENT_LINKAGE_SIMILARITY WITH (NOLOCK)
GROUP BY ROUND(token_jaccard_similarity,2)
ORDER BY ROUND(token_jaccard_similarity,2) DESC



--##################################################################
-- ALTERING MAIN TABLE TO STORE SIMILARITY SCORES
--##################################################################

ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE  ADD token_jaccard_similarity FLOAT;
ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE  ADD SAME_FLAG VARCHAR(1);
ALTER TABLE [dbo].DERV_PAPER_PATENT_LINKAGE  ADD REMARKS VARCHAR(100);

MERGE INTO [dbo].DERV_PAPER_PATENT_LINKAGE A
USING  [dbo].DERV_PAPER_PATENT_LINKAGE_SIMILARITY B
ON A.REC_ID = B.REC_ID
WHEN MATCHED THEN UPDATE 
SET A.token_jaccard_similarity = B.token_jaccard_similarity;

-- (5750913 rows affected)

SELECT TOP 100 * FROM [dbo].DERV_PAPER_PATENT_LINKAGE

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE 
SET 
SAME_FLAG = 'Y' , 
REMARKS = 'EDIT DISTANCE <= 2'
WHERE CORRECTED_NAME_DISTANCE <= 2

-- (6943055 rows affected)

UPDATE [dbo].DERV_PAPER_PATENT_LINKAGE 
SET 
SAME_FLAG = 'Y' , 
REMARKS = 'JACCARD SIMILARITY >= .5'
WHERE ROUND(token_jaccard_similarity,2) >= 0.5
-- (1051006 rows affected)


--##################################################################
-- ANALYSIS TO CHECK THE DATA
--##################################################################
SELECT COUNT(DISTINCT inventor_id) FROM
[dbo].[USPTO_g_inventor_disambiguated_TT]
-- 3864406 Inventors

SELECT count(*) 
FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
 -- 32289079 Linkage

SELECT count(distinct inventor_id) 
FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)

-- 2477952 Distinct Inventors Connected


-- Total Distinct Inventor ID Matches : 2256268, Total Distinct Author ID Matches 
SELECT count(distinct inventor_id) Connected_Inventors, count(distinct [dcterms_creator]) Connected_Authors
FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
WHERE SAME_FLAG = 'Y' 
AND SAME_FLAG IS NOT NULL 

-- Total Distinct PATENT-ID Matches : 3574214
SELECT count(distinct patent_id) 
FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
WHERE SAME_FLAG = 'Y' 
AND SAME_FLAG IS NOT NULL 


-- Type of Records which are getting Connected from Both Sides : Only Patents 3195775
SELECT entity_type, count(distinct [entity_id])
FROM [dbo].DERV_PAPER_PATENT_LINKAGE A WITH (NOLOCK) INNER JOIN [dbo].[EMAKG_Papers_TT] B 
ON A.paper_id = b.[entity_id] 
AND SAME_FLAG = 'Y'
AND SAME_FLAG IS NOT NULL 
GROUP BY entity_type


-- Check if Connected Authors have also written anything Else 
select entity_type, count(distinct Z.entity_id) from 
(
SELECT dcterms_creator, max(1) cnt
FROM [dbo].DERV_PAPER_PATENT_LINKAGE 
WITH (NOLOCK)
WHERE SAME_FLAG = 'Y'
AND SAME_FLAG IS NOT NULL 
group by dcterms_creator
)X INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] Y ON X.dcterms_creator = Y.dcterms_creator
INNER JOIN [dbo].[EMAKG_Papers_TT] Z ON Z.entity_id = Y.entity_id
GROUP BY entity_type

NULL	3918813
Book	56657
BookChapter	93575
ConferencePaper	1102657
JournalArticle	10107791
PatentDocument	10079482


-- IDENTIFY ALL RECORDS FOR SELECTED USER
SELECT 
A.paper_id , A.patent_id, B.dcterms_creator, C.class, C.foaf_name as Author_Name, D.foaf_name AS Institution_Name, D.city_name, D.state_name, D.country_name, D.country_alpha2,
E.disambig_inventor_name_first, E.disambig_inventor_name_last, CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last) AS Inventor_Name,  E.inventor_id,
F.disambig_city Inventor_City, F.disambig_state Inventor_State,  F.disambig_country Inventor_Country,
dbo.Removespecialcharatersinstring(C.foaf_name) AS Author_Name_Corrected, 
dbo.Removespecialcharatersinstring(CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last)) AS Inventor_Name_Corrected,
G.dcterms_title AS EMAKG_PAPER_TITLE, 
H.patent_title AS USPTO_PATENT_TITLE, H.patent_abstract
FROM dbo.EMAKG_Paper_Patent_Linkage_TT A
  INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] B ON A.paper_id  = B.entity_id AND dcterms_creator in ('2923280420','2257537929','2125072483','2509645873')
  INNER JOIN [dbo].[EMAKG_Authors_disambiguated_TT] C ON C.entity_id = B.dcterms_creator 
  LEFT JOIN [dbo].[EMAKG_Affiliations_TT] D ON D.entity_id = C.org_memberOf
INNER JOIN [dbo].[USPTO_g_inventor_disambiguated_TT] E ON E.patent_id = A.patent_id
LEFT JOIN [dbo].[USPTO_g_location_disambiguated_TT] F ON F.location_id = E.location_id
INNER JOIN [dbo].[EMAKG_Papers_TT] G ON G.entity_id = A.paper_id
INNER JOIN [dbo].[USPTO_g_patent_TT] H ON H.patent_id = E.patent_id  AND inventor_id IN ('fl:jo_ln:marron-5','fl:jo_ln:marrone-1')
order by B.dcterms_creator
