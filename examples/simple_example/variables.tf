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

variable "d_zone" {
  type        = string
  description = "Enter a GCP zone name where the CR solution will be deployed. E.g. us-east1-b"
  validation {
    condition = contains(["us-east1-b", "us-east1-c", "us-east1-d", "us-east4-a", "us-east4-b", "us-east4-c", "us-east5-a", "us-east5-b",
      "us-east5-c", "us-south1-a", "us-south1-b", "us-south1-c", "us-west1-a", "us-west1-b", "us-west1-c", "us-west2-a", "us-west2-b", "us-west2-c",
      "us-west3-a", "us-west3-b", "us-west3-c", "us-west4-a", "us-west4-b", "us-west4-c", "us-central1-a", "us-central1-b", "us-central1-c",
      "us-central1-c", "us-central1-f", "northamerica-northeast1-a", "northamerica-northeast1-b", "northamerica-northeast1-c", "northamerica-northeast2-a",
      "northamerica-northeast2-b", "northamerica-northeast2-c", "southamerica-east1-a", "southamerica-east1-b", "southamerica-east1-c", "southamerica-west1-a",
      "southamerica-west1-b", "southamerica-west1-c", "europe-central2-a", "europe-central2-b", "europe-central2-c", "europe-north1-a", "europe-north1-b",
      "europe-north1-c", "europe-southwest1-a", "europe-southwest1-b", "europe-southwest1-c", "europe-west1-b", "europe-west1-c", "europe-west1-d",
      "europe-west2-a", "europe-west2-b", "europe-west2-c", "europe-west3-a", "europe-west3-b", "europe-west3-c", "europe-west4-a", "europe-west4-b",
      "europe-west4-c", "europe-west6-a", "europe-west6-b", "europe-west6-c", "europe-west8-a", "europe-west8-b", "europe-west8-c", "europe-west9-a",
    "europe-west9-b", "europe-west9-c"], var.d_zone)
    error_message = "Invalid GCP zone entered"
  }
}
