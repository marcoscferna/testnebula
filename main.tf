resource "null_resource" "local_exec_example" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Hello from null_resource local-exec provisioner!'"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"

  tags = {
    environment = "dev"
    owner       = "terraform"
    managed_by  = "terraform"
  }
}

resource "azurerm_storage_account" "example" {
  name                     = "stexampledev"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"

  public_network_access_enabled = false

  blob_properties {
    container_delete_retention_policy {
      days = 7
    }
    versioning_enabled = true
  }

  network_rules {
    default_action = "Deny"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    environment = "dev"
    owner       = "terraform"
    managed_by  = "terraform"
  }
}
