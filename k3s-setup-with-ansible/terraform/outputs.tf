output "master_instance_id" {
  value = aws_instance.master.id
}

output "agent_instance_id" {
  value = aws_instance.agent.id
}

output "private_key" {
  value     = tls_private_key.k3s_key.private_key_pem
  sensitive = true
}

output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "agent_public_ip" {
  value = aws_instance.agent.public_ip
}

output "master_ip" {
  value = aws_instance.master.public_ip
}

output "agent_ip" {
  value = aws_instance.agent.public_ip
}
