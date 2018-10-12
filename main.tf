resource "null_resource" "test" {
  count = "${var.myvar}"
}
