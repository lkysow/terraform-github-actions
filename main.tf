resource "null_resource" "test1" {
  count = "${var.undeclared}"
}

variable "undeclared" {}
