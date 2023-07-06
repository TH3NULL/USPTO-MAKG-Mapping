--##################################################################
-- SQL FOR TABLE CREATION FOR EMAKG DATA
--##################################################################

CREATE TABLE dbo.EMAKG_Authors_disambiguated 
(
entity_id		VARCHAR(max),
class			VARCHAR(max),
rank			VARCHAR(max),
org#memberOf	VARCHAR(max),
foaf_name		VARCHAR(max),
paperCount		VARCHAR(max),
paperFamilyCount	VARCHAR(max),
citationCount		VARCHAR(max)
); 

commit;

CREATE TABLE dbo.EMAKG_Papers (
    [entity_id] VARCHAR(max),
    [class] VARCHAR(max),
    [entity_type] VARCHAR(max),
    [appearsInJournal] VARCHAR(max),
    [rank] VARCHAR(max),
    [estimatedCitationCount] VARCHAR(max),
    [referenceCount] VARCHAR(max),
    [appearsInConferenceSeries] VARCHAR(max),
    [familyId] VARCHAR(max),
    [appearsInConferenceInstance] VARCHAR(max),
    [citationCount] VARCHAR(max),
    [dcterms_created] VARCHAR(max),
    [dcterms_title] VARCHAR(max),
    [dcterms_publisher] VARCHAR(max),
    [prism_issueIdentifier] VARCHAR(max),
    [prism_startingPage] VARCHAR(max),
    [prism_volume] VARCHAR(max),
    [prism_endingPage] VARCHAR(max),
    [prism_publicationDate] VARCHAR(max),
    [dbo_publisher] VARCHAR(max)
)

	CREATE TABLE dbo.EMAKG_PaperFieldsOfStudy_0 (
    [entity_id] VARCHAR(20),
    [fabio_hasDiscipline] VARCHAR(20)
);

	CREATE TABLE dbo.EMAKG_PaperFieldsOfStudy_1 (
    [entity_id] VARCHAR(20),
    [fabio_hasDiscipline] VARCHAR(20)
);

	CREATE TABLE dbo.EMAKG_PaperFieldsOfStudy_2 (
    [entity_id] VARCHAR(20),
    [fabio_hasDiscipline] VARCHAR(20)
);

	CREATE TABLE dbo.EMAKG_PaperFieldsOfStudy_3 (
    [entity_id] VARCHAR(20),
    [fabio_hasDiscipline] VARCHAR(20)
);

CREATE TABLE dbo.EMAKG_PaperAuthorAffiliation (
    [paper] VARCHAR(max),
    [author] VARCHAR(max),
    [affiliation1] VARCHAR(max),
    [affiliation2] VARCHAR(max)
);

CREATE TABLE dbo.EMAKG_PaperAuthorAffiliation_large (
    [entity_id] VARCHAR(max),
    [dcterms_creator] VARCHAR(max)
);

	CREATE TABLE dbo.EMAKG_Papers_01 (
    [entity_id] VARCHAR(20),
    [class] VARCHAR(20),
    [entity_type] VARCHAR(30),
    [appearsInJournal] VARCHAR(20),
    [rank] VARCHAR(10),
    [estimatedCitationCount] VARCHAR(10),
    [referenceCount] VARCHAR(10),
    [familyId] VARCHAR(10),
    [citationCount] VARCHAR(10),
    [dcterms_created] VARCHAR(20),
    [dcterms_title] VARCHAR(3000),
    [dcterms_publisher] VARCHAR(max),
    [dbo_publisher] VARCHAR(max)
);

	CREATE TABLE dbo.EMAKG_Papers_02 (
    [entity_id] VARCHAR(20),
    [class] VARCHAR(20),
    [entity_type] VARCHAR(30),
    [appearsInJournal] VARCHAR(20),
    [rank] VARCHAR(10),
    [estimatedCitationCount] VARCHAR(10),
    [referenceCount] VARCHAR(10),
    [familyId] VARCHAR(10),
    [citationCount] VARCHAR(10),
    [dcterms_created] VARCHAR(20),
    [dcterms_title] VARCHAR(3000),
    [dcterms_publisher] VARCHAR(max),
    [dbo_publisher] VARCHAR(max)
);

	CREATE TABLE dbo.EMAKG_Papers_03 (
    [entity_id] VARCHAR(20),
    [class] VARCHAR(20),
    [entity_type] VARCHAR(30),
    [appearsInJournal] VARCHAR(20),
    [rank] VARCHAR(10),
    [estimatedCitationCount] VARCHAR(10),
    [referenceCount] VARCHAR(10),
    [familyId] VARCHAR(10),
    [citationCount] VARCHAR(10),
    [dcterms_created] VARCHAR(20),
    [dcterms_title] VARCHAR(3000),
    [dcterms_publisher] VARCHAR(max),
    [dbo_publisher] VARCHAR(max)
);

	CREATE TABLE dbo.EMAKG_Papers_09 (
    [entity_id] VARCHAR(20),
    [class] VARCHAR(20),
    [entity_type] VARCHAR(30),
    [appearsInJournal] VARCHAR(20),
    [rank] VARCHAR(10),
    [estimatedCitationCount] VARCHAR(10),
    [referenceCount] VARCHAR(10),
    [familyId] VARCHAR(10),
    [citationCount] VARCHAR(10),
    [dcterms_created] VARCHAR(20),
    [dcterms_title] VARCHAR(3000),
    [dcterms_publisher] VARCHAR(max),
    [dbo_publisher] VARCHAR(max)
);

--##################################################################
-- SQL FOR TABLE CREATION FOR USPTO DATA
--##################################################################


CREATE TABLE dbo.USPTO_g_assignee_disambiguated (
patent_id			VARCHAR(20),
assignee_sequence	VARCHAR(12),
assignee_id			VARCHAR(50),
disambig_assignee_individual_name_first		VARCHAR(100),
disambig_assignee_individual_name_last		VARCHAR(100),	
disambig_assignee_organization				VARCHAR(300),
assignee_type			VARCHAR(5),
location_id				VARCHAR(150)
);

CREATE TABLE dbo.USPTO_g_cpc_current (
patent_id			VARCHAR(20),
cpc_sequence	VARCHAR(15),
cpc_section			VARCHAR(10),
cpc_class		VARCHAR(20),
cpc_subclass		VARCHAR(20),	
cpc_group				VARCHAR(32),
cpc_type			VARCHAR(36),
cpc_symbol_position				VARCHAR(2)
);

CREATE TABLE dbo.USPTO_g_ipc_at_issue (
patent_id							VARCHAR(20),
ipc_sequence                        VARCHAR(11),
classification_level                VARCHAR(20),
section                             VARCHAR(20),
ipc_class                           VARCHAR(20),
subclass                            VARCHAR(20),
main_group                          VARCHAR(20),
subgroup                            VARCHAR(20),
symbol_position                     VARCHAR(20),
classification_value                VARCHAR(20),
classification_status               VARCHAR(20),
classification_data_source          VARCHAR(20),
action_date                         VARCHAR(20),
ipc_version_indicator               VARCHAR(20)
);


CREATE TABLE dbo.USPTO_g_patent (
patent_id			   VARCHAR(20),
patent_type	           VARCHAR(100),
patent_date            VARCHAR(20),
patent_title           VARCHAR(max),
patent_abstract        VARCHAR(max),
wipo_kind              VARCHAR(10),
num_claims             VARCHAR(11),
withdrawn              VARCHAR(11),
filename               VARCHAR(120)
);


CREATE TABLE dbo.USPTO_g_persistent_assignee (
patent_id							VARCHAR(64),
sequence                            VARCHAR(10),
disamb_assignee_id_20181127         VARCHAR(256),
disamb_assignee_id_20190312         VARCHAR(256),
disamb_assignee_id_20190820         VARCHAR(256),
disamb_assignee_id_20191008         VARCHAR(256),
disamb_assignee_id_20191231         VARCHAR(256),
disamb_assignee_id_20200331         VARCHAR(256),
disamb_assignee_id_20200630         VARCHAR(256),
disamb_assignee_id_20200929         VARCHAR(256),
disamb_assignee_id_20201229         VARCHAR(256),
disamb_assignee_id_20210330         VARCHAR(256),
disamb_assignee_id_20210629         VARCHAR(256),
disamb_assignee_id_20210930         VARCHAR(256),
disamb_assignee_id_20211230         VARCHAR(256),
disamb_assignee_id_20220630         VARCHAR(256),
disamb_assignee_id_20220929         VARCHAR(256)

);


CREATE TABLE dbo.USPTO_g_persistent_inventor (
patent_id							VARCHAR(64),
sequence                            VARCHAR(10),
disamb_inventor_id_20170808         VARCHAR(256),
disamb_inventor_id_20171003         VARCHAR(256),
disamb_inventor_id_20171226         VARCHAR(256),
disamb_inventor_id_20180528         VARCHAR(256),
disamb_inventor_id_20181127         VARCHAR(256),
disamb_inventor_id_20190312         VARCHAR(256),
disamb_inventor_id_20190820         VARCHAR(256),
disamb_inventor_id_20191008         VARCHAR(256),
disamb_inventor_id_20191231         VARCHAR(256),
disamb_inventor_id_20200331         VARCHAR(256),
disamb_inventor_id_20200630         VARCHAR(256),
disamb_inventor_id_20200929         VARCHAR(256),
disamb_inventor_id_20201229         VARCHAR(256),
disamb_inventor_id_20211230         VARCHAR(256),
disamb_inventor_id_20220630         VARCHAR(256),
disamb_inventor_id_20220929         VARCHAR(256)
);

CREATE TABLE dbo.USPTO_g_uspc_at_issue(
patent_id					VARCHAR(20),
uspc_sequence               VARCHAR(11),
uspc_mainclass_id           VARCHAR(20),
uspc_mainclass_title        VARCHAR(256),
uspc_subclass_id            VARCHAR(20),
uspc_subclass_title         VARCHAR(512)
);

CREATE TABLE dbo.USPTO_g_wipo_technology(
patent_id					VARCHAR(20),
wipo_field_sequence         VARCHAR(20),
wipo_field_id               VARCHAR(50),
wipo_sector_title           VARCHAR(60),
wipo_field_title            VARCHAR(256)
);












