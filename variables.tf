variable "master_instance_type" {
  description = "k3s server needs >= 3 GB RAM"
  type        = string
  default     = "t3.small"
}

variable "worker_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "worker_count" {
  description = "Workers are spread across the two availability zones (01 → AZ 1, 02 → AZ 2, 03 → AZ 1 …)"
  type        = number
  default     = 3
}

variable "s3_bucket" {
  description = "S3 bucket for the Terraform state, node-token and kubeconfig (same name as in the backend block)"
  type        = string
  default     = "cyberforge1-k3s-tfstate-2026"
}

variable "argocd_hostname" {
  description = "DNS name for Argo CD. Point an A record for it at the master's public IP"
  type        = string
  default     = "argocd.priniel.space"
}

variable "letsencrypt_email" {
  description = "Email Let's Encrypt uses for certificate expiry notices"
  type        = string
  default     = "chukwuebukad184@gmail.com"
}