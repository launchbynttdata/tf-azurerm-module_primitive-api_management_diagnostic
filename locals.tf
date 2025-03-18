locals {
  api_management_logger_id = "${data.azurerm_api_management.service.id}/loggers/${var.logger_name}"
}
