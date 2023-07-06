
--##################################################################
-- LOADING PaperExtendedAttribute in Python & Cleaning the Same
--##################################################################

create table dbo.EMAKG_Paper_Patent_Linkage_TT
(
paper_id 					bigint,
patent_id					VARCHAR(24)
); 

select TOP 100 * from dbo.EMAKG_Paper_Patent_Linkage
where patent_id like '%/%'
OR patent_id like '%^%'
OR patent_id like '%,%'
OR patent_id like '%>%'
OR patent_id like '%<%'
OR patent_id like '%NULL%'


insert into  dbo.EMAKG_Paper_Patent_Linkage_TT
select 
cast(paper_id as bigint),
( CASE WHEN patent_id = 'NULL' THEN NULL ELSE patent_id  END ) 
from dbo.EMAKG_Paper_Patent_Linkage;



CREATE INDEX IDX_EMAKG_Paper_Patent_Linkage_TT_1 ON [dbo].EMAKG_Paper_Patent_Linkage_TT(paper_id);
CREATE INDEX IDX_EMAKG_Paper_Patent_Linkage_TT_2 ON [dbo].EMAKG_Paper_Patent_Linkage_TT(patent_id);


select count(*) from dbo.EMAKG_Paper_Patent_Linkage
74423615
select count(*) from dbo.EMAKG_Paper_Patent_Linkage_TT
74423615

drop table dbo.EMAKG_Paper_Patent_Linkage

commit;

