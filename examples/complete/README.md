# complete

Please set a provider block with the following, to avoid soft-deletes of the APIM instance which can cause problems with the tests
```
provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
  }
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.117 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_apim"></a> [apim](#module\_apim) | terraform.registry.launch.nttdata.com/module_primitive/api_management/azurerm | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"dso"` | no |
| <a name="input_product_service"></a> [product\_service](#input\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"apim"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | Azure Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "api_management": {<br>    "max_length": 50,<br>    "name": "apim"<br>  },<br>  "resource_group": {<br>    "max_length": 50,<br>    "name": "rg"<br>  }<br>}</pre> | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer,<br>    Basic, Standard and Premium. The second part is the capacity. Default is Consumption\_0. | `string` | `"Consumption_0"` | no |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | The name of publisher/company. | `string` | `"launchdso"` | no |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | The email of publisher/company. | `string` | `"launchdso@nttdata.com"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Should the API Management Service be accessible from the public internet?<br>    This option is applicable only to the Management plane, not the API gateway or Developer portal.<br>    It is required to be true on the creation.<br>    For sku=Developer/Premium and network\_type=Internal, it must be true.<br>    It can only be set to false if there is at least one approve private endpoint connection. | `bool` | `true` | no |
| <a name="input_virtual_network_type"></a> [virtual\_network\_type](#input\_virtual\_network\_type) | The type of virtual network you want to use, valid values include: None, External, Internal.<br>    External and Internal are only supported in the SKUs - Premium and Developer | `string` | `"None"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Identifier of the Diagnostics Logs. Must be either 'applicationinsights' or 'azuremonitor'. | `string` | `null` | no |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | The percentage of requests to sample. Default is '100.0'. | `number` | `100` | no |
| <a name="input_always_log_errors"></a> [always\_log\_errors](#input\_always\_log\_errors) | Indicates whether to always log errors. Default is 'true'. | `bool` | `true` | no |
| <a name="input_log_client_ip"></a> [log\_client\_ip](#input\_log\_client\_ip) | Indicates whether to log the client IP address. Default is 'false'. | `bool` | `false` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | The verbosity level applied to the diagnostic. Must be either 'error', 'information', or 'verbose'. Default is 'error'. | `string` | `"error"` | no |
| <a name="input_http_correlation_protocol"></a> [http\_correlation\_protocol](#input\_http\_correlation\_protocol) | The protocol to use for correlation. Must be either 'W3C', 'Legacy', or 'None'. Default is 'W3C'. | `string` | `"W3C"` | no |
| <a name="input_operation_name_format"></a> [operation\_name\_format](#input\_operation\_name\_format) | The format of the operation name for Application Insights telemetries. Must be either 'Name' or 'Url'. Default is 'Name'. | `string` | `"Name"` | no |
| <a name="input_backend_request"></a> [backend\_request](#input\_backend\_request) | Options for logging requests being forwarded to a backend service | <pre>object({<br>    body_bytes     = optional(number, 0)<br>    headers_to_log = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_backend_response"></a> [backend\_response](#input\_backend\_response) | Options for logging responses from backend services | <pre>object({<br>    body_bytes     = optional(number, 0)<br>    headers_to_log = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_frontend_request"></a> [frontend\_request](#input\_frontend\_request) | Options for logging requests from clients | <pre>object({<br>    body_bytes     = optional(number, 0)<br>    headers_to_log = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_frontend_response"></a> [frontend\_response](#input\_frontend\_response) | Options for logging responses sent to clients | <pre>object({<br>    body_bytes     = optional(number, 0)<br>    headers_to_log = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_management_name"></a> [api\_management\_name](#output\_api\_management\_name) | The name of the API Management Service |
| <a name="output_api_management_id"></a> [api\_management\_id](#output\_api\_management\_id) | The ID of the API Management Service |
| <a name="output_api_management_gateway_url"></a> [api\_management\_gateway\_url](#output\_api\_management\_gateway\_url) | The URL of the Gateway for the API Management Service |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
