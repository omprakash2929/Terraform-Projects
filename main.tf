module "dev-infra" {
    source = "./Infra"
    env = "dev"
    bucket_name = "infra_app"
    instance_count = 1
    Ec2_instance_type = "t2.micro"
    Ec2_ami_id = "ami-0d0f28110d16ee7d6"
    ec2_deafult_root_storage_size = 15
    hash_key = "studentID"
  
}