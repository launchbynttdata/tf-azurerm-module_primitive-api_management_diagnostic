output "diagnostic_resource_id" {
  value = azurerm_api_management_diagnostic.diagnostic[0].id
}

output "diagnostic_identifier" {
  value = azurerm_api_management_diagnostic.diagnostic[0].identifier
}
