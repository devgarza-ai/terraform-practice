output "instance_id" {
  value = aws_instance.web.id
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"
}
