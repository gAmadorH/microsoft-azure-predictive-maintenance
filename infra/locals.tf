locals {
  # Si no pasas var.db_password, se usa el random generado
  db_password_effective = length(var.db_password) > 0 ? var.db_password : random_password.db.result
}
