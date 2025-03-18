# this SKU is quickest to provision, but theres a limit of 20 per subscription
sku_name        = "Consumption_0"
publisher_name  = "launchdso@nttdata.com"
publisher_email = "launchdso@nttdata.com"

virtual_network_type = "None"

# backend variables
name        = "terratest-backend"
protocol    = "http"
url         = "https://example.com"
description = "terratest backend"
resource_id = null
title       = "terratest backend"

credentials = {
  authorization = {
    scheme    = "Basic"
    parameter = "some+base64+string"
  }
  header = {
    "header1" = "value1,value2"
  }
  query = {
    "param1" = "value1"
  }
}

tls = {
  validate_certificate_chain = true
  validate_certificate_name  = true
}
