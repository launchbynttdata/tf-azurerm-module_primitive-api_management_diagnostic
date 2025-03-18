data "azurerm_api_management" "service" {
  name                = var.api_management_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_diagnostic" "diagnostic" {
  count = (var.api_name == null) ? 1 : 0

  identifier                = var.identifier
  resource_group_name       = var.resource_group_name
  api_management_name       = var.api_management_name
  api_management_logger_id  = local.api_management_logger_id
  sampling_percentage       = var.sampling_percentage
  always_log_errors         = var.always_log_errors
  log_client_ip             = var.log_client_ip
  verbosity                 = var.verbosity
  http_correlation_protocol = var.http_correlation_protocol

  dynamic "backend_request" {
    for_each = var.backend_request != null ? [var.backend_request] : []
    content {
      body_bytes     = var.backend_request.body_bytes
      headers_to_log = var.backend_request.headers_to_log
    }
  }

  dynamic "backend_response" {
    for_each = var.backend_response != null ? [var.backend_response] : []
    content {
      body_bytes     = var.backend_response.body_bytes
      headers_to_log = var.backend_response.headers_to_log
    }
  }

  dynamic "frontend_request" {
    for_each = var.frontend_request != null ? [var.frontend_request] : []
    content {
      body_bytes     = var.frontend_request.body_bytes
      headers_to_log = var.frontend_request.headers_to_log
    }
  }

  dynamic "frontend_response" {
    for_each = var.frontend_response != null ? [var.frontend_response] : []
    content {
      body_bytes     = var.frontend_response.body_bytes
      headers_to_log = var.frontend_response.headers_to_log
    }
  }
}
