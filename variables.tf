/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# variable "a_credentials" {
#   type        = string
#   description = "Enter the full path to the credentials file to be used by the Google Provider. Leave empty if you want to use gcloud authentication."
# }

variable "b_project" {
  type        = string
  description = "Enter a GCP project name where the CR solution will be deployed"
}

variable "c_region" {
  type        = string
  description = "Enter a GCP region name where the CR solution will be deployed. E.g. us-east1"
  validation {
    condition = contains(["us-east1", "us-east4", "us-east5", "us-south1", "us-west1", "us-west2", "us-west3", "us-west4",
      "us-central1", "northamerica-northeast1", "northamerica-northeast2", "southamerica-east1", "southamerica-west1", "europe-central2",
      "europe-north1", "europe-southwest1", "europe-west1", "europe-west2", "europe-west3", "europe-west4", "europe-west6", "europe-west8",
    "europe-west9"], var.c_region)
    error_message = "Invalid GCP region entered"
  }

}

variable "e_prefix" {
  type        = string
  description = "Enter a prefix to be used when naming resources in GCP. Must be at most 11 lowercase alphanumeric characters."
  validation {
    condition     = length(var.e_prefix) <= 11
    error_message = "Prefix cannot be more than 11 characters"
  }
  validation {
    condition     = can(regex("^[a-z0-9]*$", var.e_prefix))
    error_message = "Prefix must contain only lower case alphanumeric characters."
  }
}

variable "f_subnet_1_CIDR" {
  type        = string
  description = "Enter a valid CIDR range for the Jump Host subnet. E.g. 10.0.0.0/28"
  validation {
    condition     = can(cidrnetmask(var.f_subnet_1_CIDR))
    error_message = "Invalid CIDR range entered. Check example given."
  }
}

variable "g_subnet_2_CIDR" {
  type        = string
  description = "Enter a valid CIDR range for the DDVE and Mgmt Host subnet. E.g. 10.0.0.16/28"
  validation {
    condition     = can(cidrnetmask(var.g_subnet_2_CIDR))
    error_message = "Invalid CIDR range entered. Check example given."
  }
}

variable "h_subnet_3_CIDR" {
  type        = string
  description = "Enter a valid CIDR range for the DDVE replication subnet. E.g. 192.168.1.0/28"
  validation {
    condition     = can(cidrnetmask(var.h_subnet_3_CIDR))
    error_message = "Invalid CIDR range entered. Check example given."
  }
}

#variable "i_production_dd_CIDR" {
#type = string
#description = "Enter a valid CIDR range for the production DD system"
#default = "10.10.10.25/32"
#}

variable "j_production_client_CIDR" {
  type        = string
  description = "Enter a valid CIDR range for the client system(s) that will access the Jump Host. E.g. 10.10.10.10/32"
  validation {
    condition     = can(cidrnetmask(var.j_production_client_CIDR))
    error_message = "Invalid CIDR range entered. Check example given."
  }
}
