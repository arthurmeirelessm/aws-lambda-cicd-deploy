variable "handler" {
  type        = string
  description = "Ponto de entrada da função, por ex.: arquivo.funcao"
}

variable "runtime" {
  type        = string
  description = "Runtime do Lambda, por ex.: python3.11"
}

variable "source_path" {
  type        = string
  description = "Caminho até o diretório do código-fonte a ser zipado"
}

variable "layer_initial_zip_path" {
  type        = string
  description = ""
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role que o Lambda irá assumir"
}

variable "lambda_name" {
  type = string
}


variable "layer_name" {
  type = string
}

variable "layer_bucket" {
  type = string
}

variable "local_source_path" {
  type = string
}

