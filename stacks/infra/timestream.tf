resource "aws_timestreamwrite_database" "events_store" {
  database_name = var.timestream_db_name
#  kms_key_id    = aws_kms_key.timestream_kms_key.arn
}

resource "aws_timestreamwrite_table" "events_store" {
  depends_on = [aws_timestreamwrite_database.events_store]
  database_name = var.timestream_db_name
  table_name    = var.timestream_table_name
  magnetic_store_write_properties {
    enable_magnetic_store_writes = true
  }

  retention_properties {
    magnetic_store_retention_period_in_days = 73000
    memory_store_retention_period_in_hours  = 8
  }
}
