# this SKU is quickest to provision, but theres a limit of 20 per subscription
sku_name        = "Consumption_0"
publisher_name  = "launchdso@nttdata.com"
publisher_email = "launchdso@nttdata.com"

virtual_network_type = "None"

logger_name = "terratest-logger"

identifier = "applicationinsights"

backend_request = {
  bytes_to_log   = 8192
  headers_to_log = ["X-Terratest-Header"]
}

frontend_request = {
  bytes_to_log   = 0
  headers_to_log = ["X-Forwarded-For"]
}
