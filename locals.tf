locals {
  api_management_logger_id = "${data.azurerm_api_management.service.id}/loggers/${var.logger_name}"

  api_management_diagnostic = one(coalesce(
    azurerm_api_management_diagnostic.diagnostic,
    azurerm_api_management_api_diagnostic.diagnostic
  ))
}
