CREATE OR REPLACE FILE FORMAT FORMAT.CSV_FORMAT
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL')
  SKIP_HEADER = 1; 