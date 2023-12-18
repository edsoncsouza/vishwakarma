resource "tls_private_key" "ca" {
  count = var.self_signed ? 1 : 1

  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "tls_cert_request" "request" {
  count = var.self_signed ? 0 : 1

  private_key_pem = tls_private_key.ca[count.index].private_key_pem

  subject {
    common_name  = var.cert_config["common_name"]
    organization = var.cert_config["organization"]
  }


}

resource "tls_self_signed_cert" "ca" {
  count = var.self_signed ? 1 : 0

  private_key_pem = tls_private_key.ca[count.index].private_key_pem

  subject {
    common_name  = var.cert_config["common_name"]
    organization = var.cert_config["organization"]
  }

  is_ca_certificate     = true
  validity_period_hours = var.cert_config["validity_period_hours"]

  allowed_uses = var.ca_uses
}

resource "tls_locally_signed_cert" "ca" {
  count = var.self_signed ? 0 : 1

  cert_request_pem = tls_cert_request.request[count.index].cert_request_pem

  ca_private_key_pem    = var.ca_config["key_pem"]
  ca_cert_pem           = var.ca_config["cert_pem"]
  validity_period_hours = var.cert_config["validity_period_hours"]

  is_ca_certificate = true
  allowed_uses      = var.ca_uses
}
