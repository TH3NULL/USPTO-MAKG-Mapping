EXTRACT MAKG Publication Data for Unique Inventors in USPTO Database by directly Querying from SPARQL Endpoint.

1. Download Zippped TSV file for Inventors from https://s3.amazonaws.com/data.patentsview.org/download/g_inventor_disambiguated.tsv.zip

2. Use the *g_inventor_disambiguated.ipynb* notebook to extract data in CSV format from the above downloaded file.
3. Import the CSV file into the notebook *Approach_1_Notebook.ipynb* and run the entire notebook.
4. Ensure to download all the necessary libraries.
5. Presently the code extracts data for the first 15 unique inventors, however that could be changed in code to extract for more inventors.

###### *SPARQL Queries to explore endpoint file* gives the user a chance to directly query from the SPARQL Endpoint (https://makg.org/sparql)
