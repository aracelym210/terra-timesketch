variable "region" {
    description = "GCP region to deploy to"
    type = string
    default = "us-central1"
}

variable "zone" {
    description = "GCP zone to deploy to"
    type = string
    default = "us-central1-a"
}

variable "network" {
    description = "Name of VPC network to use for this deployment. Defaults to 'default' VPC."
    type = string
    default = "default"
}

variable "project_id" {
  description = "Value of the GCP project ID you wish to deploy to"
  type        = string
  default     = "<PROJECT-ID>"
  sensitive   = true
}

variable "machine_type" {
    description = "GCE machine type for your GCE instance/ VM. 8GB RAM is the minimum recommended."
    type = string
    default = "e2-standard-2"
}

variable "image" {
    description = "Boot image/ operating system for your GCE instance. Ubuntu 22.04 is required for Timesketch"
    type = string
    default = "ubuntu-2204-lts"
}

variable "service_account" {
    description = "Service account email address to allow GCE instance to read from storage (GCS) buckets"
    type = string
    default = "<SERVICE-ACCOUNT>@<PROJECT-ID>.iam.gserviceaccount.com"
    sensitive = true 
}

