--##################################################################
-- MERGING THE DATA
--##################################################################

DROP TABLE [dbo].DERV_FINAL_MAPPPING;

-- INSERTING DATA FROM PAPER-PATENT LINKAGE
SELECT distinct 'PATENT-PAPER-LINKAGE'  LINKAGE_TYPE,
dcterms_creator, Author_Name, inventor_id, Inventor_Name
INTO [dbo].DERV_FINAL_MAPPING
FROM 
[dbo].DERV_PAPER_PATENT_LINKAGE 
WHERE SAME_FLAG = 'Y' 
AND SAME_FLAG IS NOT NULL


-- INSERTING DATA FROM TITLE & NAME LINKAGE
INSERT INTO [dbo].DERV_FINAL_MAPPING
SELECT distinct 'TITLE-NAME-LINKAGE'  LINKAGE_TYPE,
dcterms_creator, Author_Name, inventor_id, Inventor_Name
FROM 
[dbo].DERV_TITLE_MAPPING_IDS
WHERE SAME_FLAG = 'Y' 
AND SAME_FLAG IS NOT NULL

SELECT TOP 100 * FROM 
[dbo].DERV_FINAL_MAPPING
WHERE inventor_id = 'fl:cr_ln:zificsak-1' AND dcterms_creator = '6226051'


--##################################################################
-- GENERATING FINDINGS
--##################################################################

SELECT count(distinct inventor_id) Connected_Inventors, count(distinct [dcterms_creator]) Connected_Authors FROM 
[dbo].DERV_FINAL_MAPPING

-- 2501363 Connected_Inventors	& 3790437 Connected_Authors

	SELECT inventor_id, dcterms_creator, count(distinct LINKAGE_TYPE) CNT_LINKAGES
	INTO [dbo].DERV_CNT
	FROM [dbo].DERV_FINAL_MAPPING
	group by inventor_id, dcterms_creator 
	having count(distinct LINKAGE_TYPE)  = 2;

SELECT TOP 100 * FROM [dbo].DERV_CNT

DROP TABLE [dbo].DERV_CNT


--##################################################################
-- IDENTFYING TIME VARIANCE OF LOCATION WITH TIME FOR AUTHOR & INVENTOR
--##################################################################

SELECT patent_id, inventor_id, disambig_inventor_name_first, disambig_inventor_name_last, 
A.location_id, disambig_city, disambig_state, disambig_country FROM 
[dbo].[USPTO_g_inventor_disambiguated_TT] A
INNER JOIN [dbo].[USPTO_g_location_disambiguated_TT] F ON F.location_id = A.location_id
AND inventor_id = 'fl:jo_ln:marrone-1'


SELECT TOP 100 * FROM 
[dbo].[EMAKG_Authors_disambiguated_TT]
WHERE foaf_name = 'Ali Rajabzadeh'
