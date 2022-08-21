terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.25.0"
    }
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "iam" { # Enable IAM API
  provider = google-beta
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifactregistry" { # Enable Artifact Registry API
  provider = google-beta
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudrun" { # Enable Cloud Run API
  provider = google-beta
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_run_api" {
  provider = google-beta
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "resourcemanager" { # Enable Cloud Resource Manager API
  provider = google-beta
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "wait_30_seconds" { # This is used so there is some time for the activation of the API's to propagate through Google Cloud before actually calling them.
  create_duration = "30s"
  
  depends_on = [
    google_project_service.iam,
    google_project_service.artifactregistry,
    google_project_service.cloudrun,
    google_project_service.cloud_run_api,
    google_project_service.resourcemanager
    ]
}

resource "google_artifact_registry_repository" "flask_template_repo" { # Create Artifact Registry Repository for Docker containers
  provider = google-beta
  location = var.region
  repository_id = var.docker_repo
  description = "Flask template docker repo"
  format = "DOCKER"
  depends_on = [time_sleep.wait_30_seconds]
}

resource "google_cloud_run_service" "default" { # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
  name     = var.project_name
  project  = var.project_id
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.docker_repo}/${var.docker_image}" # google artifactory repo (not docker)
        resources {
          limits = {
          "memory" = "1G"
          "cpu" = "1"
          }
        }
      }
    }
     metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"      = "0"
        "autoscaling.knative.dev/maxScale"      = "2"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# All cloud run services are deployed privately by default - auth is secured by IAM
# https://cloud.google.com/run/docs/authenticating/overview
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam
resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  service  = google_cloud_run_service.default.name
  project  = var.project_id

  policy_data = data.google_iam_policy.noauth.policy_data
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}