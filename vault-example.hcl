backend "consul" {
  address = "192.168.59.103:8500"
  advertise_addr = "http://127.0.0.1:8200"
  scheme = "http"
  path = "vault"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}
