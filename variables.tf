variable "location" {
  type        = string
  description = "Région Azure où déployer les ressources"
  default     = "eastus"
}

variable "prefix" {
  type        = string
  description = "Plage d'adresses du sous-réseau"
  default     = "tp-azure"
}
variable "subscription_id" {
  type        = string
  description = "ID de la souscription Azure"
  sensitive   = true
}