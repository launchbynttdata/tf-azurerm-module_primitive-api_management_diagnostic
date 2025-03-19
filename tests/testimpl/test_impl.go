package testimpl

import (
	"context"
	"os"
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

		options := arm.ClientOptions{
			ClientOptions: azcore.ClientOptions{
				Cloud: cloud.AzurePublic,
			},
		}

		diagnosticClient, err := apiManagement.NewDiagnosticClient(subscriptionId, credential, &options)
		if err != nil {
			t.Fatalf("Error getting API Management diagnostic client: %v", err)
		}

		diagnostic, err := diagnosticClient.Get(context.Background(), resourceGroupName, serviceName, diagnosticIdentifier, nil)
		if err != nil {
			t.Fatalf("Error getting API Management diagnostic: %v", err)
		}

		assert.Equal(t, diagnosticResourceId, *diagnostic.ID)
	})
}
