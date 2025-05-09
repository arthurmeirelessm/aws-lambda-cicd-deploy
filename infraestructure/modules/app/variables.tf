variable "lambda_function_name" {
  type        = string
  description = "Nome que o Lambda vai receber"
}

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

variable "local_build_path" {
  type        = string
  description = ""
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role que o Lambda irá assumir"
}
