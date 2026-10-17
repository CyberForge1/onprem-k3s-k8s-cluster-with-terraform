# ---- cert-manager: issues and renews TLS certificates from Let's Encrypt ----
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.21.2"
  namespace        = "cert-manager"
  create_namespace = true

  values = [yamlencode({
    crds = {
      enabled = true
    }
  })]

  depends_on = [aws_instance.ec2_instance_worker]
}
# letsencrypt-staging and letsencrypt-prod ClusterIssuers
resource "helm_release" "cluster_issuer" {
  name       = "cluster-issuer"
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  namespace  = helm_release.cert_manager.namespace

  values = [yamlencode({
    resources = [
      {
        apiVersion = "cert-manager.io/v1"
        kind       = "ClusterIssuer"
        metadata   = { name = "letsencrypt-staging" }
        spec = {
          acme = {
            server              = "https://acme-staging-v02.api.letsencrypt.org/directory"
            email               = var.letsencrypt_email
            privateKeySecretRef = { name = "letsencrypt-staging" }
            solvers             = [{ http01 = { ingress = { class = "nginx" } } }]
          }
        }
      },
      {
        apiVersion = "cert-manager.io/v1"
        kind       = "ClusterIssuer"
        metadata   = { name = "letsencrypt-prod" }
        spec = {
          acme = {
            server              = "https://acme-v02.api.letsencrypt.org/directory"
            email               = var.letsencrypt_email
            privateKeySecretRef = { name = "letsencrypt-prod" }
            solvers             = [{ http01 = { ingress = { class = "nginx" } } }]
          }
        }
      }
    ]
  })]

  depends_on = [helm_release.cert_manager]
}