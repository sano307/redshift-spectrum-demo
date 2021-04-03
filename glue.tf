resource "aws_glue_catalog_database" "demo_database" {
  name = "demo-database"
}

resource "aws_glue_crawler" "demo_crawler" {
  name = "demo-crawler"

  database_name = aws_glue_catalog_database.demo_database.name
  role          = aws_iam_role.glue.arn
  table_prefix  = "demo_"

  configuration = jsonencode({
    "Version" = 1.0,
    "Grouping" : {
      "TableGroupingPolicy" : "CombineCompatibleSchemas"
    }
  })

  s3_target {
    path = "s3://${var.s3_bucket_parquet}/parquet"
  }
}
