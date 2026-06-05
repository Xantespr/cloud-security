# GitHub Actions CI/CD Setup Guide

How to connect a GitHub repository with your Azure subscription to automate the deployment of your infrastructure using code.

---

## Prerequisites
* An active Azure Subscription.
* Azure Resource Group.
* A GitHub repository containing your Bicep files.

---

## Step 1: Generate Azure Service Principal
You need to create a virtual identity (Service Principal) that allows GitHub Actions to securely connect to your Azure Resource Group.

1. Open **Azure Cloud Shell** (Bash environment).
2. Run the following command (replace `<Your-Subscription-ID>` with your actual Azure Subscription ID):

```bash
az ad sp create-for-rbac \
  --name "github-actions-<something>" \
  --role contributor \
  --scopes /subscriptions/<Your-Subscription-ID>/resourceGroups/<Your-resourceGroup-name> \
  --json-auth								

## Step 2: Configure GitHub Secrets
Settings -> Secrets and variables -> Actions -> New repository secret -> add "AZURE_CREDENTIALS" and "AZURE_SUBSCRIPTION_ID"

## Step 3 Infrastructure as Code (Modular Bicep)
This template leverages a modular architecture. The `main.bicep` file acts as an orchestrator (root module) that triggers independent sub-modules.
```
```
your-root-repository/
│
├── .github/
│   └── workflows/
│       └── deploy-infrastructure.yml
│
└── <YOUR_INFRASTRUCTURE_FOLDER>/
    ├── main.bicep
    └── modules/
        ├── core.bicep
	    └── any-other-resource.bicep
```
