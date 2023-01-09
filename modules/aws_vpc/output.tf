output "vpc_id" {
  value       = aws_vpc.main.id
  sensitive   = true
  description = "description"
  depends_on  = []
}
