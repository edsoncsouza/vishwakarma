output "algorithm" {
  value = join("", tls_private_key.ca.*.algorithm)
}

output "rsa_bits" {
  value = var.rsa_bits
}

output "private_key_pem" {
  value = join("", tls_private_key.ca.*.private_key_pem)

  sensitive = true
}

output "cert_pem" {
  value     = var.self_signed ? join("", tls_self_signed_cert.ca.*.cert_pem) : join("", tls_locally_signed_cert.ca.*.cert_pem)
  sensitive = true
}
