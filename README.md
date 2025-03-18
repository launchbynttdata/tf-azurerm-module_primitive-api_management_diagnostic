# tf-azurerm-module_primitive-api_management_diagnostic

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module provisions an Azure API Management diagnostic. It can be deployed to either the API Management instance, or an individual API.
It can be used to log errors, request bodies/headers, and response bodies/headers. Sampling is recommended for high traffic workloads.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.117 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_diagnostic.diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_diagnostic) | resource |
| [azurerm_api_management.service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group where the APIM exists | `string` | `null` | no |
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | name of the APIM in which this diagnostic will de deployed | `string` | `null` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | name of the API within the APIM to apply the diagnostic. when omitted, the diagnostic will be created for all APIs | `string` | `null` | no |
| <a name="input_logger_name"></a> [logger\_name](#input\_logger\_name) | name of the logger within the APIM | `string` | `null` | no |
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

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostic_resource_id"></a> [diagnostic\_resource\_id](#output\_diagnostic\_resource\_id) | n/a |
| <a name="output_diagnostic_identifier"></a> [diagnostic\_identifier](#output\_diagnostic\_identifier) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
