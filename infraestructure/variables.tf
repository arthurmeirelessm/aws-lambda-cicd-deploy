variable "github_oauth_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
  default     = ""
}



variable "enable_cicd" {
  type        = bool
  description = "Habilita ou desabilita o módulo de CI/CD"
  default     = false
}
