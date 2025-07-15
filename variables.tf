variable "resource_group_name" {
  type        = string
  description = "name of the resource group where the APIM exists"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.resource_group_name))
    error_message = "The resource group name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "api_management_name" {
  type        = string
  description = "name of the APIM in which this diagnostic will de deployed"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.api_management_name))
    error_message = "The APIM name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "api_name" {
  type        = string
  description = "name of the API within the APIM to apply the diagnostic. when omitted, the diagnostic will be created for all APIs"
  default     = null
  validation {
    condition     = var.api_name == null || can(regex("^[a-zA-Z0-9-]{1,50}$", var.api_name))
    error_message = "The APIM name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "logger_name" {
  type        = string
  description = "name of the logger within the APIM"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.logger_name))
    error_message = "The logger name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "identifier" {
  type        = string
  description = "Identifier of the Diagnostics Logs. Must be either 'applicationinsights' or 'azuremonitor'."
  default     = null
  validation {
    condition     = contains(["applicationinsights", "azuremonitor"], var.identifier)
    error_message = "The diagnostic identifier must be either 'applicationinsights' or 'azuremonitor'."
  }
}

# note: enabling the logging feature caused a 40%-50% reduction in throughput when request rate exceeded 1,000 requests per second
# https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-app-insights?tabs=rest#performance-implications-and-log-sampling
variable "sampling_percentage" {
  type        = number
  description = "The percentage of requests to sample. Default is '100.0'. Higher percentages may impact performance at high request rates."
  default     = 100.0
  validation {
    condition     = var.sampling_percentage >= 0.0 && var.sampling_percentage <= 100.0
    error_message = "The sampling percentage must be between 0.0 and 100.0."
  }
}

variable "always_log_errors" {
  type        = bool
  description = "Indicates whether to always log errors. Default is 'true'."
  default     = true
}

variable "log_client_ip" {
  type        = bool
  description = "Indicates whether to log the client IP address. Default is 'false'."
  default     = false
}

variable "verbosity" {
  type        = string
  description = "The verbosity level applied to the diagnostic. Must be either 'error', 'information', or 'verbose'. Default is 'error'."
  default     = "error"
  validation {
    condition     = contains(["error", "information", "verbose"], var.verbosity)
    error_message = "The verbosity level must be either 'error', 'information', or 'verbose'."
  }
}

variable "http_correlation_protocol" {
  type        = string
  description = "The protocol to use for correlation. Must be either 'W3C', 'Legacy', or 'None'. Default is 'W3C'."
  default     = "W3C"
  validation {
    condition     = contains(["W3C", "Legacy", "None"], var.http_correlation_protocol)
    error_message = "The HTTP correlation protocol must be either 'W3C', 'Legacy', or 'None'."
  }
}

variable "operation_name_format" {
  type        = string
  description = "The format of the operation name for Application Insights telemetries. Must be either 'Name' or 'Url'. Default is 'Name'."
  default     = "Name"
  validation {
    condition     = contains(["Name", "Url"], var.operation_name_format)
    error_message = "The operation name format must be either 'Name' or 'Url'."
  }
}

variable "backend_request" {
  type = object({
    body_bytes     = optional(number, 0)
    headers_to_log = optional(list(string), [])
  })
  description = "Options for logging requests being forwarded to a backend service"
  default     = null

  validation {
    condition = var.backend_request == null || (
      try(var.backend_request.body_bytes >= 0 && var.backend_request.body_bytes <= 8192, false)
    )
    error_message = "The body_bytes must be a number in the range [0, 8192]."
  }
}

variable "backend_response" {
  type = object({
    body_bytes     = optional(number, 0)
    headers_to_log = optional(list(string), [])
  })
  description = "Options for logging responses from backend services"
  default     = null

  validation {
    condition = var.backend_response == null || (
      try(var.backend_response.body_bytes >= 0 && var.backend_response.body_bytes <= 8192, false)
    )
    error_message = "The body_bytes must be a number in the range [0, 8192]."
  }
}

variable "frontend_request" {
  type = object({
    body_bytes     = optional(number, 0)
    headers_to_log = optional(list(string), [])
  })
  description = "Options for logging requests from clients"
  default     = null

  validation {
    condition = var.frontend_request == null || (
      try(var.frontend_request.body_bytes >= 0 && var.frontend_request.body_bytes <= 8192, false)
    )
    error_message = "The body_bytes must be a number in the range [0, 8192]."
  }
}

variable "frontend_response" {
  type = object({
    body_bytes     = optional(number, 0)
    headers_to_log = optional(list(string), [])
  })
  description = "Options for logging responses sent to clients"
  default     = null

  validation {
    condition = var.frontend_response == null || (
      try(var.frontend_response.body_bytes >= 0 && var.frontend_response.body_bytes <= 8192, false)
    )
    error_message = "The body_bytes must be a number in the range [0, 8192]."
  }
}
