terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
    files = fileset(path.module, "manifests/*.yaml")
}

variable "namespace" {
    type = string
    default = "pulp"
}

variable "service_account" {
    type = string
    default = "pulp"
}

variable "operator_image" {
   type = string
   default = "quay.io/pulp/pulp-operator:v1.0.0"
}

variable "deploy_simple" {
   type = bool
   default = false
}

variable "deploy_settings_cm" {
  type = bool
  default = false
}

resource "kubernetes_namespace" "ns" {
    metadata {
        name = var.namespace
    }
}

resource "kubernetes_manifest" "roles" {
  for_each = local.files
  manifest = yamldecode(templatefile("${each.value}",{ namespace = var.namespace , service_account = var.service_account, image = var.operator_image }))
}
