resource "azurerm_resource_group" "ri-u-inc-inp-dpm-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

#######################  storage_account" #########################
resource "azurerm_storage_account" "ri-u-inc-inp-dpm-sqlstoracc" {
  name                     = "ridincdpmsqlacc"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

######################## SQL server #################################
resource "azurerm_sql_server" "ri-u-inc-inp-dpm-sql" {
  name                         = "ri-u-inc-inp-sqlserver"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  version                      = "12.0"
  administrator_login          = "misadmin"
  administrator_login_password = "wallYear1234"

  tags = {
    environment = "UAT"
  }
}

############################ SQL DB one  ################################

resource "azurerm_sql_database" "ri-u-inc-inp-dpm-db" {
  name                = "ri-u-inc-inp-dpm-sdb"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  server_name         = azurerm_sql_server.ri-u-inc-inp-dpm-sql.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.ri-u-inc-inp-dpm-sqlstoracc.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.ri-u-inc-inp-dpm-sqlstoracc.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "UAT"
  }
}

######################### service plans WAPP service   ###########################################  
resource "azurerm_app_service_plan" "ri-u-inc-inp-dpm-wapp" {
  name                = "ridpmwappserviceplan"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "ri-u-inc-inp-dpm-dac-01-wapp" {
  name                = "ri-dpm-wapp-service"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.ri-u-inc-inp-dpm-wapp.id

  site_config {
    dotnet_framework_version = "v4.0"
####  scm_type                 = "LocalGit"
#  }
#
#  app_settings = {
#    "SOME_KEY" = "some-value"
##  }
##
#  connection_string {
#   name  = "Database"
#    type  = "SQLServer"
#   value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
######################### service plans for API   ########################################### 
resource "azurerm_app_service_plan" "ri-u-inc-inp-dpm-api" {
  name                = "ridpmapiserviceplan"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_app_service" "ri-u-inc-inp-dpm-api-service" {
  name                = "ri-dpm-api-service"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.ri-u-inc-inp-dpm-api.id

  site_config {
    dotnet_framework_version = "v4.0"
 ####  scm_type                 = "LocalGit"
##  }
#
#  app_settings = {
#    "SOME_KEY" = "some-value"
##  }
##
#  connection_string {
#   name  = "Database"
#    type  = "SQLServer"
#   value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
} 