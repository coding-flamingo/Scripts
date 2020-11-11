$logininfo = az login | ConvertFrom-Json
$akvName ="codingflamingopsakv"
$location ="westus2"
$resourceGroup ="MyResourceGroup"

if((az group exists -n $resourceGroup) -eq $false)
{
    Write-Host -ForegroundColor Magenta "Creating Resource Group"
    az group create -l $location -n $resourceGroup 
}

#create AKV
az keyvault create --location $location --name $akvName --resource-group $resourceGroup --sku "standard"

#get details
az keyvault show --name $akvName

#Set policy for UPN
$username =  ""
az keyvault set-policy -n $akvName  --upn $username --key-permissions get list --secret-permissions delete get list purge recover restore set --certificate-permissions create delete

#Set Policy for Service Principal
$servicePrincipal = ""
az keyvault set-policy -n $akvName --spn $servicePrincipal --key-permissions get list  --secret-permissions delete get list purge recover restore set --certificate-permissions create delete

#Set Policy for Object ID
$objectID = ""
az keyvault set-policy -n $akvName --object-id $objectID --key-permissions get list  --secret-permissions delete get list purge recover restore set --certificate-permissions create delete


#set secret
$secretName = "myfirst"
$secret = Read-Host 'Secret Value' -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
$plainSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
az keyvault secret set --name $secretName --vault-name $akvName --value $plainSecret

#get Secret
az keyvault secret show --name $secretName --vault-name $akvName 
