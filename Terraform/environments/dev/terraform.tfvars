key_name            = "Myops"
ami_id              = "ami-08fe5144e4659a3b3"
min_size            = 1
max_size            = 2
desired_capacity    = 1
instance_type       = "t3.medium"
subnet_ids          = [
  "subnet-0738b2e70f37fe442", # ap-south-1a
  "subnet-04cf194b656ad564e", # ap-south-1c
  "subnet-03b17848527227137"  # ap-south-1b
]
instance_profile_name = "ecsInstanceProfile"
ec2_security_group_names = ["default", "All_Security"]
ec2_security_groups     = ["sg-0106a2994ff8e49aa", "sg-0a35e9086b143cac5"]
user_data            = "file(\"userdata.sh\")"  # Or inline userdata content
environment         = "dev"
project_name        = "ror-ecs-project"
