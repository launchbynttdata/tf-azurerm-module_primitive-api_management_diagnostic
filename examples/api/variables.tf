// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
variable "product_family" {
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  type        = string
  default     = "dso"
}

variable "product_service" {
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  type        = string
  default     = "apim"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "Azure Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    resource_group = {
      name       = "rg"
      max_length = 50
    }
    api_management = {
      name       = "apim"
      max_length = 50
    }
    app_insights = {
      name       = "appinsights"
      max_length = 50
    }
    log_analytics_workspace = {
      name       = "law"
      max_length = 50
    }
  }
}

# APIM settings

variable "sku_name" {
  type        = string
  description = <<EOT
    String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer,
    Basic, Standard and Premium. The second part is the capacity. Default is Consumption_0.
  EOT
  default     = "Consumption_0"
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
  default     = "launchdso"
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
  default     = "launchdso@nttdata.com"
}

variable "public_network_access_enabled" {
  description = <<EOT
    Should the API Management Service be accessible from the public internet?
    This option is applicable only to the Management plane, not the API gateway or Developer portal.
    It is required to be true on the creation.
    For sku=Developer/Premium and network_type=Internal, it must be true.
    It can only be set to false if there is at least one approve private endpoint connection.
  EOT
  type        = bool
  default     = true
}

variable "virtual_network_type" {
  type        = string
  description = <<EOT
    The type of virtual network you want to use, valid values include: None, External, Internal.
    External and Internal are only supported in the SKUs - Premium and Developer
  EOT
  default     = "None"
}

# Logger settings
variable "logger_name" {
  type        = string
  description = "name of the logger"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.logger_name))
    error_message = "The backend name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

# Diagnostic settings
variable "identifier" {
  type        = string
  description = "Identifier of the Diagnostics Logs. Must be either 'applicationinsights' or 'azuremonitor'."
  default     = null
  validation {
    condition     = can(regex("^(applicationinsights|azuremonitor)$", var.identifier))
    error_message = "The diagnostic identifier must be either 'applicationinsights' or 'azuremonitor'."
  }
}

# note: enabling the logging feature caused a 40%-50% reduction in throughput when request rate exceeded 1,000 requests per second
# https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-app-insights?tabs=rest#performance-implications-and-log-sampling
variable "sampling_percentage" {
  type        = number
  description = "The percentage of requests to sample. Default is '100.0'."
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
    condition     = can(regex("^(error|information|verbose)$", var.verbosity))
    error_message = "The verbosity level must be either 'error', 'information', or 'verbose'."
  }
}

variable "http_correlation_protocol" {
  type        = string
  description = "The protocol to use for correlation. Must be either 'W3C', 'Legacy', or 'None'. Default is 'W3C'."
  default     = "W3C"
  validation {
    condition     = can(regex("^(W3C|Legacy|None)$", var.http_correlation_protocol))
    error_message = "The HTTP correlation protocol must be either 'W3C', 'Legacy', or 'None'."
  }
}

variable "operation_name_format" {
  type        = string
  description = "The format of the operation name for Application Insights telemetries. Must be either 'Name' or 'Url'. Default is 'Name'."
  default     = "Name"
  validation {
    condition     = can(regex("^(Name|Url)$", var.operation_name_format))
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

# APIM API settings
variable "api_name" {
  type        = string
  description = "name of the API"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9- ]{1,50}$", var.api_name))
    error_message = "The title can only contain alphanumeric characters, dashes, or spaces and must be between 1 and 50 characters long."
  }
}

variable "api_revision" {
  type        = string
  description = "revision of the API"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,50}$", var.api_revision))
    error_message = "The APIM name can only contain alphanumeric characters and dashes and must be between 1 and 50 characters long."
  }
}

variable "api_display_name" {
  type        = string
  description = "display name of the API"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9- ]{1,50}$", var.api_display_name))
    error_message = "The display name can only contain alphanumeric characters, dashes, or spaces and must be between 1 and 50 characters long."
  }
}

variable "api_path" {
  type        = string
  description = "path of the API"
  default     = null
  validation {
    condition     = can(regex("^[a-zA-Z0-9/-]{1,50}$", var.api_path))
    error_message = "The path can only contain alphanumeric characters, dashes, or forward slashes and must be between 1 and 50 characters long."
  }
}

# Common settings

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
