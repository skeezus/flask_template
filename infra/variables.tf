variable "project_id" {
  description  = "The name of the project"
  type         = string
  default      = "flask-template-15608"
}

variable "project_name" {
  description  = "The name of the project"
  type         = string
  default      = "flask-template"
}

variable "environment" {
  description  = "The container environment"
  type         = string
  default      = "production"
}

variable "docker_image" {
  description = "The name of the Docker image in the Artifact Registry repository to be deployed to Cloud Run"
  type        = string
  default     = "flask-template:latest"
}

variable "docker_repo" {
  description = "The name of the Artifact Registry repository to be created"
  type        = string
  default     = "flask-template"
}

variable "region" {
  description  = "The default compute zone"
  type         = string
  default      = "us-central1"
}

variable "zone" {
  description  = "The default compute zone"
  type         = string
  default      = "us-central1-c"
}