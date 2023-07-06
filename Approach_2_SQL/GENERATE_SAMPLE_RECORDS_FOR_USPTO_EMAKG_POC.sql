
--##################################################################
-- LOADING SELECTED TABLES 
--##################################################################

-- Selecting Sample Patents Records for POC
SELECT * 
INTO CAPS_POC_USPTO_inventor_disambiguated
  FROM [patentview_trial].[dbo].[g_inventor_disambiguated]
  where patent_id in 
  (
'10000000',
'10000001',
'10000002',
'10000003',
'10000004',
'10000005',
'10000006',
'10000007',
'10000008',
'10000009',
'10000010',
'10000011',
'10000014',
'10000015'
)

--##################################################################
-- SQL FOR DEDUP OF RECORD FOREIGN PRIORITY FOR USPTO_g_foreign_priority
--##################################################################

-- SQL CODE FOR DETERMINING MAX OF RECORDS 
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
-- SQL FOR SAMPLE RECORD FOR USPTO 
--##################################################################

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
A.patent_id,A.inventor_sequence, A.inventor_id, A.disambig_inventor_name_first, A.disambig_inventor_name_last, A.male_flag	, A.location_id,
B.disambig_city, B.disambig_state, B.disambig_country, B.latitude, B.longitude,
C.disambig_assignee_individual_name_first, C.disambig_assignee_individual_name_last, C.disambig_assignee_organization,
D.patent_type, D.patent_title, D.patent_abstract, D.num_claims, 
(
case 
when SUBSTRING(F.cpc_class,1,1) = 'A' then 'Human Necessitates'
when SUBSTRING(F.cpc_class,1,1) = 'B' then 'Performing Operations Transporting'
when SUBSTRING(F.cpc_class,1,1) = 'C' then 'Chemistry Metallurgy'
when SUBSTRING(F.cpc_class,1,1) = 'D' then 'Textiles Paper'
when SUBSTRING(F.cpc_class,1,1) = 'E' then 'Fixed Constructions'
when SUBSTRING(F.cpc_class,1,1) = 'F' then 'Mechanical Engineering Lighting Heating Weapons Blasting Engines or Pumps'
when SUBSTRING(F.cpc_class,1,1) = 'G' then 'Physics'
when SUBSTRING(F.cpc_class,1,1) = 'H' then 'Electricity'
when SUBSTRING(F.cpc_class,1,1) = 'Y' then 'General Tagging of New Technological Developments'
else F.cpc_class
END
) AS PATENT_CATEGORY,  
F.cpc_subclass,F.cpc_subclass_title,F.cpc_group,F.cpc_group_title,F.cpc_class,F.cpc_class_title,
G.application_id, G.filing_date AS application_filing_date, 
H.priority_claim_kind, H.foreign_application_id,H.filing_date, H.foreign_country_filed
--into dbo.CAPS_POC_USPTO_FINAL_DATA_v1 
FROM dbo.CAPS_POC_USPTO_inventor_disambiguated A 
INNER JOIN [dbo].[USPTO_g_location_disambiguated_TT] B on A.location_id = B.location_id
LEFT JOIN [dbo].[USPTO_g_assignee_disambiguated_TT] C ON C.patent_id = A.patent_id
LEFT JOIN [dbo].[USPTO_g_patent_TT] D ON D.patent_id = A.patent_id
--LEFT JOIN [dbo].g_pct_data E ON E.patent_id = A.patent_id 
LEFT JOIN [dbo].USPTO_g_cpc_current_TT E ON E.patent_id = A.patent_id and E.cpc_sequence = '0'
LEFT JOIN [dbo].USPTO_g_cpc_title_TT F ON F.cpc_class = E.cpc_class and F.cpc_subclass = E.cpc_subclass and F.cpc_group = E.cpc_group
LEFT JOIN [dbo].USPTO_g_application_TT G ON G.patent_id = A.patent_id
LEFT JOIN [dbo].USPTO_g_foreign_priority_MAX_REC_TT H ON H.patent_id = A.patent_id


--##################################################################
-- SQL FOR SAMPLE RECORD FROM MAKG 
--##################################################################


DROP TABLE [dbo].[CAPS_POC_EMAKG_Authors];

select *
into [dbo].[CAPS_POC_EMAKG_Authors]
from 
[dbo].EMAKG_Authors_disambiguated_TT
where 
( foaf_name like '%Dong%' and foaf_name like '%Hyeon%' and foaf_name like '%Choi%'                                                 )
or ( foaf_name like '%Dong%' and foaf_name like '%Jin%' and foaf_name like '%Kim%'                                                    )
or ( foaf_name like '%Si%' and foaf_name like '%Min%' and foaf_name like '%Kim%'                                                      )
or ( foaf_name like '%Yun%' and foaf_name like '%Jo%' and foaf_name like '%Kim%'                                                      )
or ( foaf_name like '%Katsunori%' and foaf_name like '%Oda%'                                                   )
or ( foaf_name like '%Kenji%' and foaf_name like '%Katou%'                                                     )
or ( foaf_name like '%Herbert%' and foaf_name like '%Schall%'                                                  )
or ( foaf_name like '%Tim%' and foaf_name like '%DIEHLMANN%'                                                   )
or ( foaf_name like '%Franz%' and foaf_name like '%Josef%' and foaf_name like '%Dietzen%'                                             )
or ( foaf_name like '%Carsten%' and foaf_name like '%SANDNER%'                                                 )
or ( foaf_name like '%Dietrich%' and foaf_name like '%Scherzer%'                                               )
or ( foaf_name like '%Jose%' and foaf_name like '%Juan%' and foaf_name like '%Valadez Lopez%'                                         )
or ( foaf_name like '%Miguel Jorge%' and foaf_name like '%Zubiria Elizondo%'                                   )
or ( foaf_name like '%Marc%' and foaf_name like '%Saelen%'                                                     )
or ( foaf_name like '%Cristoph%' and foaf_name like '%Mehren%'                                                 )
or ( foaf_name like '%Guido%' and foaf_name like '%Bergmann%'                                                  )
or ( foaf_name like '%Carsten%' and foaf_name like '%Elsasser%'                                                )
or ( foaf_name like '%Hyeon Jae%' and foaf_name like '%YU%'                                                    )
or ( foaf_name like '%Sun%' and foaf_name like '%Woo%' and foaf_name like '%Lee%'                                                     )
or ( foaf_name like '%Carlos%' and foaf_name like '%Terrero%'                                               )
or ( foaf_name like '%Brian%' and foaf_name like '%Hanna%'                                                  )
or ( foaf_name like '%Lynn%' and foaf_name like '%Saxton%'                                                     )
or ( foaf_name like '%Donald%' and foaf_name like '%Fess%'                                                  )
or ( foaf_name like '%Roberto%' and foaf_name like '%Irizarry%'                                             )
or ( foaf_name like '%Jarrod%' and foaf_name like '%Kotes%'                                                    )
or ( foaf_name like '%Corey%' and foaf_name like '%Dickert%'                                                   )
or ( foaf_name like '%Will%' and foaf_name like '%Didier%'                                                     )
or ( foaf_name like '%Ian%' and foaf_name like '%Zimmermann%'                                                  )
or ( foaf_name like '%Alex%' and foaf_name like '%Huber%'                                                      )
or ( foaf_name like '%Nathan%' and foaf_name like '%Christopher%' and foaf_name like '%Maier%'                                        )
or ( foaf_name like '%Gregory%' and foaf_name like '%Thomas%' and foaf_name like '%Mark%'                                             )
or ( foaf_name like '%Joseph%' and foaf_name like '%Marron%'                                                   )
or ( foaf_name like '%Robert%' and foaf_name like '%Nick%'                                                  )
or ( foaf_name like '%Liah%' and foaf_name like '%Caspi%'                                                      )

CREATE INDEX IDX_CAPS_POC_EMAKG_Authors_1 ON [dbo].[CAPS_POC_EMAKG_Authors]([entity_id]);


--##################################################################
-- SQL FOR GENERATING REPORTS FOR EMAKG DATA
--##################################################################

select --TOP 1000 * 
A.entity_id as author_id, A.class as Author_class, A.org_memberof, A.foaf_name As Author_Name, A.paperCount, A.paperFamilyCount, A.citationCount, 
B.paper as Paper_Id, B.affiliation1 , 
C.foaf_name as Affliation_Name, C.foundation_date,C.type_entities,C.pos_lat,C.pos_long,C.city_name,C.city_lat,C.city_lon,C.state_name,C.postcode,C.country_name,C.country_alpha2,C.country_alpha3,C.country_official_name,
D.class as Paper_Class,D.entity_type Paper_Entity_Type,D.appearsInJournal,D.estimatedCitationCount,D.referenceCount,D.dcterms_created,D.dcterms_title,D.dcterms_publisher,D.dbo_publisher,
F.foaf_name AS Field_of_Study_Name, 
G.fos_list AS Field_list
from [dbo].[CAPS_POC_EMAKG_Authors] A
inner join [dbo].[EMAKG_PaperAuthorAffiliation_TT] B on A.entity_id = B.author
LEFT JOIN [dbo].[EMAKG_Affiliations_TT] C on C.entity_id = B.affiliation1
INNER JOIN [dbo].[EMAKG_Papers_TT] D on D.entity_id = B.paper
left join [dbo].[EMAKG_PaperFieldsOfStudy_TT] E on E.entity_id = B.paper
left join [dbo].[EMAKG_FieldsOfStudy_TT] F on F.entity_id = E.fabio_hasDiscipline
left join [dbo].[EMAKG_FieldOfStudyLabeled_TT] G On G.entity_id = F.entity_id


