package testimpl

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	apiManagement "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/apimanagement/armapimanagement"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

// clientFactory holds the Azure clients needed for testing
type clientFactory struct {
	apiDiagnosticClient *apiManagement.APIDiagnosticClient
	diagnosticClient    *apiManagement.DiagnosticClient
}

// newClientFactory creates a new client factory with initialized Azure clients
func newClientFactory(t *testing.T, subscriptionId string, credential *azidentity.DefaultAzureCredential) *clientFactory {
	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	apiDiagnosticClient, err := apiManagement.NewAPIDiagnosticClient(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("Error getting API Management API diagnostic client: %v", err)
	}

	diagnosticClient, err := apiManagement.NewDiagnosticClient(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("Error getting API Management diagnostic client: %v", err)
	}

	return &clientFactory{
		apiDiagnosticClient: apiDiagnosticClient,
		diagnosticClient:    diagnosticClient,
	}
}

// getDiagnostic retrieves a diagnostic based on whether an API name is provided
func (cf *clientFactory) getDiagnostic(ctx context.Context, resourceGroupName, serviceName, apiName, diagnosticIdentifier string) (*apiManagement.DiagnosticContract, error) {
	if len(apiName) > 0 {
		// If an API name is provided, we check for API-specific diagnostics
		response, err := cf.apiDiagnosticClient.Get(ctx, resourceGroupName, serviceName, apiName, diagnosticIdentifier, nil)
		if err != nil {
			return nil, err
		}
		return &response.DiagnosticContract, nil
	}
	// Otherwise, we check for service-level diagnostics
	response, err := cf.diagnosticClient.Get(ctx, resourceGroupName, serviceName, diagnosticIdentifier, nil)
	if err != nil {
		return nil, err
	}
	return &response.DiagnosticContract, nil
}

func TestApiManagementModule(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	t.Run("doesApiManagementDiagnosticExist", func(t *testing.T) {
		resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
		serviceName := terraform.Output(t, ctx.TerratestTerraformOptions(), "api_management_name")
		diagnosticIdentifier := terraform.Output(t, ctx.TerratestTerraformOptions(), "diagnostic_identifier")
		diagnosticResourceId := terraform.Output(t, ctx.TerratestTerraformOptions(), "diagnostic_resource_id")

		var apiName = ""
		if strings.Contains(diagnosticResourceId, fmt.Sprintf("%s/apis", serviceName)) {
			apiName = terraform.Output(t, ctx.TerratestTerraformOptions(), "api_management_api_name")
		}

		clientFactory := newClientFactory(t, subscriptionId, credential)

		diagnostic, err := clientFactory.getDiagnostic(context.Background(), resourceGroupName, serviceName, apiName, diagnosticIdentifier)
		if err != nil {
			t.Fatalf("Error getting API Management diagnostic: %v", err)
		}

		assert.Equal(t, diagnosticResourceId, *diagnostic.ID)
	})
}
