provider "vault" {
  address = "http://127.0.01:8200"
  token = "s.Yfcg7YjdmDRBGGIyVrMn3f6L"
    # using the root token like this is not a best practice, in fact we should not use it like this
}

data "vault_generic_secret" "phone_number" {
  path = "secret/app"
}

output "phone_number" {
  value = data.vault_generic_secret.phone_number
  sensitive = true
}

resource "aws_instance" "app" {
  password = data.vault_generic_secret.phone_number.data["phone_number"]
}