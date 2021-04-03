CREATE EXTERNAL SCHEMA "demo_spec" FROM DATA CATALOG
DATABASE 'demo-database'
IAM_ROLE 'arn:aws:iam::YOUR_ACCOUNT_ID:role/redshift-role';
