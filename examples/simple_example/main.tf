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

provider "google" {
  # credentials = var.a_credentials != "" ? file("${var.a_credentials}") : null
  project = var.b_project
  region  = var.c_region
  zone    = var.d_zone
}

module "dell_marketplace" {
  source = "../.."

  b_project                = var.b_project
  c_region                 = var.c_region
  e_prefix                 = "dellxyz"
  f_subnet_1_CIDR          = "10.128.1.0/28"
  g_subnet_2_CIDR          = "10.128.2.0/28"
  h_subnet_3_CIDR          = "10.128.3.0/28"
  j_production_client_CIDR = "10.128.4.0/28"
}
