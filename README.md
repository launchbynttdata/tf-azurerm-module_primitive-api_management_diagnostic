# tf-azurerm-module_primitive-api_management_diagnostic

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This Terraform module creates an Azure API Management diagnostic. It can be attached to the API Management instance or to an individual API. It can log errors, request bodies/headers, and response bodies/headers. Sampling is recommended for high-traffic workloads.

## Usage

See [examples/api](examples/api) and [examples/service](examples/service) for deployable examples.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.117 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_diagnostic.diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_diagnostic.diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_diagnostic) | resource |
| [azurerm_api_management.service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_always_log_errors"></a> [always\_log\_errors](#input\_always\_log\_errors) | Indicates whether to always log errors. Default is 'true'. | `bool` | `true` | no |
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | name of the APIM in which this diagnostic will de deployed | `string` | `null` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | name of the API within the APIM to apply the diagnostic. when omitted, the diagnostic will be created for all APIs | `string` | `null` | no |
| <a name="input_backend_request"></a> [backend\_request](#input\_backend\_request) | Options for logging requests being forwarded to a backend service | <pre>object({<br/>    body_bytes     = optional(number, 0)<br/>    headers_to_log = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_backend_response"></a> [backend\_response](#input\_backend\_response) | Options for logging responses from backend services | <pre>object({<br/>    body_bytes     = optional(number, 0)<br/>    headers_to_log = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_frontend_request"></a> [frontend\_request](#input\_frontend\_request) | Options for logging requests from clients | <pre>object({<br/>    body_bytes     = optional(number, 0)<br/>    headers_to_log = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_frontend_response"></a> [frontend\_response](#input\_frontend\_response) | Options for logging responses sent to clients | <pre>object({<br/>    body_bytes     = optional(number, 0)<br/>    headers_to_log = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_http_correlation_protocol"></a> [http\_correlation\_protocol](#input\_http\_correlation\_protocol) | The protocol to use for correlation. Must be either 'W3C', 'Legacy', or 'None'. Default is 'W3C'. | `string` | `"W3C"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Identifier of the Diagnostics Logs. Must be either 'applicationinsights' or 'azuremonitor'. | `string` | `null` | no |
| <a name="input_log_client_ip"></a> [log\_client\_ip](#input\_log\_client\_ip) | Indicates whether to log the client IP address. Default is 'false'. | `bool` | `false` | no |
| <a name="input_logger_name"></a> [logger\_name](#input\_logger\_name) | name of the logger within the APIM | `string` | `null` | no |
| <a name="input_operation_name_format"></a> [operation\_name\_format](#input\_operation\_name\_format) | The format of the operation name for Application Insights telemetries. Must be either 'Name' or 'Url'. Default is 'Name'. | `string` | `"Name"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group where the APIM exists | `string` | `null` | no |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | The percentage of requests to sample. Default is '100.0'. Higher percentages may impact performance at high request rates. | `number` | `100` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | The verbosity level applied to the diagnostic. Must be either 'error', 'information', or 'verbose'. Default is 'error'. | `string` | `"error"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostic_identifier"></a> [diagnostic\_identifier](#output\_diagnostic\_identifier) | n/a |
| <a name="output_diagnostic_resource_id"></a> [diagnostic\_resource\_id](#output\_diagnostic\_resource\_id) | n/a |
<!-- END_TF_DOCS -->

## Module Development

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run the `make configure` command from the root of the repository to ensure that you meet these requirements.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to Terraform and Golang, as well as some common linting tasks. These will be configured for you when you run `make configure`.

### Local Validation

You should validate the changes you make to any module locally, prior to pushing your changes in a branch to GitHub.

1. Ensure that you have run `make configure` successfully.

2. Ensure you are signed into the appropriate cloud provider (e.g. AWS or Azure) for the module under test in your current console session.

3. Run the Terraform and Golang linters with the following command:

```
make lint
```

4. Once you have satisfied the linters, the following command will build example infrastructure in your configured cloud, run the tests, and then tear down the infrastructure it created:

```
make test
```

The pre-commit validations, as well as the `make lint` and `make test` targets, will all be performed in CI. Running these validations locally prior to opening a PR helps ensure a smooth review and merge process.

### Review & Merge Process

Once your change has been tested locally and your branch pushed up, open a new Pull Request for your branch to the default (main) branch of this repository.

The title of your Pull Request will determine the version bump for this change, and the title must be in [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format in order to merge. A breaking change will trigger a major version bump, a feature will trigger a minor version bump, and all other types will trigger a patch version bump.

Ensure your CI workflows are passing; seek approval from teammates and address any feedback; seek any explicit approvals required by the CODEOWNERS file. You may merge the PR as soon as all requirements are met, and a new release and tag will be automatically created for you.

### Automatic Updates

The shared configuration and workflow files in this repository are largely managed through the [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton) repository. Outside of perhaps the `.gitignore` to account for specific files being generated by certain Terraform modules (e.g. Lambda functions), there should not be much cause to update these files on a per-repo basis, and making changes to them individually is discouraged.

If desired, you can check for and run these updates locally in a branch if you have the `copier` tool installed. Some example commands are included below:

```
# Check for updates, optionally checking prerelease versions
copier check-update [--prereleases]

# Run an update, using default answers if there are any. We use tasks, which requires --trust to be set.
copier update --defaults --trust [--prereleases]

# Recopy from the source, and --overwrite all templated files in the process
copier recopy --defaults --trust --overwrite [--prereleases]
```

Automatic updates will run through a scheduled workflow, and if the post-update tests are successful, the Pull Request created will automatically merge. Conflicts in the update or failures to test may leave a Pull Request outstanding, which needs to be addressed by a Launch Engineer.
