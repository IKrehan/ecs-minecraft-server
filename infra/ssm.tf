resource "aws_ssm_parameter" "type" {
  name        = "/minecraft/type"
  description = "A type of minecraft. ie: VANILLA, MODRINTH, etc."
  type        = "String"
  value       = "VANILLA"
}

resource "aws_ssm_parameter" "version" {
  name        = "/minecraft/version"
  description = "The version of minecraft. ie: 1.20.1, 1.19.0, LATEST, etc."
  type        = "String"
  value       = "LATEST"
}

resource "aws_ssm_parameter" "modpack_url" {
  name        = "/minecraft/modpack_url"
  description = "If type is set to MODRINTH, select the desired modpack with thin "
  type        = "String"
  value       = "NONE"
}