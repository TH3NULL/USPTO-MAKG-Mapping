
--##################################################################
-- MERGING RECORDS BASED ON PAPER TITLE 
--##################################################################

select TOP 100 * FROM [dbo].[USPTO_g_patent_TT]
5008469

select TOP 100 * FROM [dbo].[EMAKG_Papers_TT] where entity_type = 'PatentDocument'
52873589

--##################################################################
-- IDENTIFY THE PATENTS IN USPTO WHERE LINKAGES NOT FOUND
--##################################################################

-- CREATING DUMMY TABLES

	select TOP 100 A.patent_id, A.patent_title, B.patent_id AS EXIST_IN_LINKAGE
	INTO [dbo].DUMMY_TABLE
	FROM [dbo].[USPTO_g_patent_TT] A
	LEFT JOIN 
	(
	select patent_id, max(1) exist FROM 
	[dbo].DERV_PAPER_PATENT_LINKAGE 
	group by patent_id
	) B
	ON A.patent_id = B.patent_id
	AND 1=2

-- IDENTIFY THE PATENTS WHERE LINKAGES NOT FOUND
	TRUNCATE TABLE [dbo].DUMMY_TABLE;

-- INSERTING INTO DUMMY TABLES 
	INSERT INTO [dbo].DUMMY_TABLE 
	select A.patent_id, A.patent_title, B.patent_id AS EXIST_IN_LINKAGE
	FROM [dbo].[USPTO_g_patent_TT] A
	LEFT JOIN 
	(
	select patent_id, max(1) exist FROM 
	[dbo].DERV_PAPER_PATENT_LINKAGE 
	group by patent_id
	) B
	ON A.patent_id = B.patent_id;

-- INSERTING INTO MAIN TABLES 
	SELECT * 
	INTO [dbo].DERV_USPTO_PATENT_NO_LINKAGE
	FROM [dbo].DUMMY_TABLE
	WHERE EXIST_IN_LINKAGE IS NULL 

-- DROP TABLE [dbo].DUMMY_TABLE
   SELECT TOP 100 * FROM  [dbo].DERV_USPTO_PATENT_NO_LINKAGE

   UPDATE [dbo].DERV_USPTO_PATENT_NO_LINKAGE SET patent_title = UPPER(patent_title);

--##################################################################
-- IDENTIFY THE EMAKG PAPERES WHERE LINKAGES NOT FOUND
--##################################################################

SELECT TOP 100 * FROM  
[dbo].[EMAKG_Papers_TT]

-- CREATING DUMMY TABLE 
	SELECT TOP 100 A.entity_id, A.dcterms_title, B.paper_id AS EXIST_IN_LINKAGE
	INTO [dbo].DUMMY_TABLE
	FROM
		(select entity_id, dcterms_title  FROM [dbo].[EMAKG_Papers_TT] WHERE entity_type = 'PatentDocument') A
	LEFT JOIN 
		(select paper_id, max(1) exist FROM [dbo].DERV_PAPER_PATENT_LINKAGE group by paper_id) B 
	ON A.entity_id = B.paper_id
	AND 1=2;

-- IDENTIFY THE PATENTS WHERE LINKAGES NOT FOUND
	TRUNCATE TABLE [dbo].DUMMY_TABLE;
DROP TABLE  [dbo].DUMMY_TABLE_2
-- CREATING DUMMY 1 FOR DISTINCT PAPER_IDs
   select paper_id, max(1) cnt INTO [dbo].DUMMY_TABLE_1 FROM [dbo].DERV_PAPER_PATENT_LINKAGE group by paper_id

-- CREATING DUMMY 2 FOR PAPER AND TITLES
   select entity_id, UPPER(dcterms_title) dcterms_title INTO [dbo].DUMMY_TABLE_2 FROM [dbo].[EMAKG_Papers_TT] WHERE entity_type = 'PatentDocument'


-- INSERTING INTO DUMMY TABLES 
	INSERT INTO [dbo].DUMMY_TABLE 
	SELECT A.entity_id, A.dcterms_title, B.paper_id AS EXIST_IN_LINKAGE
	FROM
		[dbo].DUMMY_TABLE_2 A
	LEFT JOIN 
		[dbo].DUMMY_TABLE_1 B 
	ON A.entity_id = B.paper_id;
	
-- INSERTING INTO MAIN TABLES 
	SELECT * 
	INTO [dbo].DERV_EMAKG_PAPER_NO_LINKAGE
	FROM [dbo].DUMMY_TABLE
	WHERE EXIST_IN_LINKAGE IS NULL 


-- DROP TABLE [dbo].DUMMY_TABLE
   SELECT TOP 100 * FROM  [dbo].DERV_EMAKG_PAPER_NO_LINKAGE

--##################################################################
-- MATCHING BOTH COMPONENTS
--##################################################################
SELECT TOP 100 * FROM  [dbo].DERV_USPTO_PATENT_NO_LINKAGE
1120765

SELECT TOP 100 * FROM  [dbo].DERV_EMAKG_PAPER_NO_LINKAGE
49517613


SELECT COUNT(*)
FROM  [dbo].DERV_USPTO_PATENT_NO_LINKAGE A
INNER JOIN [dbo].DERV_EMAKG_PAPER_NO_LINKAGE B
ON A.patent_title = B.dcterms_title; 


-- CREATE TABLE FOR PATENT LINKAGE
SELECT 
A.PATENT_ID USPTO_PATENT_ID, A.PATENT_TITLE USPTO_PATENT_TITLE, B.ENTITY_ID EMAKG_PAPER_ID, 
B.dcterms_title EMAKG_PAPER_TITLE
INTO [dbo].DERV_TITLE_MAPPING
FROM  [dbo].DERV_USPTO_PATENT_NO_LINKAGE A
INNER JOIN [dbo].DERV_EMAKG_PAPER_NO_LINKAGE B
ON A.patent_title = B.dcterms_title AND 1=0

-- INSERT FOR LINKAGE
INSERT INTO [dbo].DERV_TITLE_MAPPING
SELECT 
A.PATENT_ID USPTO_PATENT_ID, A.PATENT_TITLE USPTO_PATENT_TITLE, B.ENTITY_ID EMAKG_PAPER_ID, 
B.dcterms_title EMAKG_PAPER_TITLE
FROM  [dbo].DERV_USPTO_PATENT_NO_LINKAGE A
INNER JOIN [dbo].DERV_EMAKG_PAPER_NO_LINKAGE B
ON A.patent_title = B.dcterms_title; 

-- (1113704 rows affected)


-- CREATE TABLE FOR AUTHOR & INVENTOR DETAILS OF LINKED PATENTS

--DROP TABLE [dbo].DERV_TITLE_MAPPING_IDS;

SELECT 
ROW_NUMBER() OVER(ORDER BY USPTO_PATENT_ID DESC) REC_ID,
A.USPTO_PATENT_ID, A.USPTO_PATENT_TITLE, A.EMAKG_PAPER_ID, A.EMAKG_PAPER_TITLE, 
B.dcterms_creator, UPPER(C.foaf_name) as Author_Name,
E.inventor_id, UPPER(CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last)) AS Inventor_Name 
INTO [dbo].DERV_TITLE_MAPPING_IDS
FROM
[dbo].DERV_TITLE_MAPPING A 
INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] B ON A.EMAKG_PAPER_ID  = B.entity_id AND 1=0
INNER JOIN [dbo].[EMAKG_Authors_disambiguated_TT] C ON C.entity_id = B.dcterms_creator 
INNER JOIN [dbo].[USPTO_g_inventor_disambiguated_TT] E ON E.patent_id = A.USPTO_PATENT_ID


-- INSERT INTO TABLE FOR AUTHOR & INVENTOR DETAILS OF LINKED PATENTS
INSERT INTO [dbo].DERV_TITLE_MAPPING_IDS
SELECT 
ROW_NUMBER() OVER(ORDER BY USPTO_PATENT_ID DESC) REC_ID,
A.USPTO_PATENT_ID, A.USPTO_PATENT_TITLE, A.EMAKG_PAPER_ID, A.EMAKG_PAPER_TITLE, 
B.dcterms_creator, UPPER(C.foaf_name) as Author_Name,
E.inventor_id, UPPER(CONCAT(E.disambig_inventor_name_first,' ',E.disambig_inventor_name_last)) AS Inventor_Name 
FROM
[dbo].DERV_TITLE_MAPPING A 
INNER JOIN [dbo].[EMAKG_PaperAuthorAffiliation_large_TT] B ON A.EMAKG_PAPER_ID  = B.entity_id 
INNER JOIN [dbo].[EMAKG_Authors_disambiguated_TT] C ON C.entity_id = B.dcterms_creator 
INNER JOIN [dbo].[USPTO_g_inventor_disambiguated_TT] E ON E.patent_id = A.USPTO_PATENT_ID

-- (8802574 rows affected)

UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Author_Name = dbo.Removespecialcharatersinstring(Author_Name);
UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Inventor_Name = dbo.Removespecialcharatersinstring(Inventor_Name);

UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Author_Name = REPLACE(Author_Name,'  ',' ');
UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Author_Name = REPLACE(Author_Name,'  ',' ');
UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Author_Name = REPLACE(Author_Name,'  ',' ') where Author_Name LIKE '%  %';

UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Inventor_Name = REPLACE(Inventor_Name,'  ',' ') where Inventor_Name LIKE '%  %';
UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Inventor_Name = REPLACE(Inventor_Name,'  ',' ') where Inventor_Name LIKE '%  %';
UPDATE [dbo].DERV_TITLE_MAPPING_IDS  SET Inventor_Name = REPLACE(Inventor_Name,'  ',' ') where Inventor_Name LIKE '%  %';



TRUNCATE TABLE [dbo].DERV_TITLE_MAPPING_IDS;

ALTER TABLE [dbo].DERV_TITLE_MAPPING_IDS  ADD token_jaccard_similarity FLOAT;

-- LOAD THE TABLE FROM PYTHON AND STORE HERE AGAIN

ALTER TABLE [dbo].DERV_TITLE_MAPPING_IDS  ADD SAME_FLAG VARCHAR(1);
ALTER TABLE [dbo].DERV_TITLE_MAPPING_IDS  ADD REMARKS VARCHAR(100);


UPDATE [dbo].DERV_TITLE_MAPPING_IDS 
SET 
SAME_FLAG = 'Y' , 
REMARKS = 'JACCARD SIMILARITY >= .5'
WHERE ROUND(token_jaccard_similarity,2) >= 0.5
-- (965874 rows affected)



-- IDENTIFYING DISTINCT INVENTOR IDs WHERE LINKAGE FOUND
SELECT count(distinct inventor_id) FROM [dbo].DERV_TITLE_MAPPING_IDS  WITH (NOLOCK) 
where token_jaccard_similarity >= 0.5

498410


