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

environment_variables = [
  {
    name  = "DB_USER"
    value = "myuser"
  },
  {
    name  = "DB_PASSWORD"
    value = "mypassword"
  },
  {
    name  = "DB_HOST"
    value = "rorchatapp.c342ea4cs6ny.ap-south-1.rds.amazonaws.com"
  },
  {
    name  = "DB_PORT"
    value = "5432"
  },
  {
    name  = "DB_NAME"
    value = "rorchatapp"
  },
  {
    name  = "REDIS_URL"
    value = "redis://redis:6379/0"
  },
  {
    name  = "RAILS_MASTER_KEY"
    value = "c3ca922688d4bf22ac7fe38430dd8849"
  },
  {
    name  = "SECRET_KEY_BASE"
    value = "600f21de02355f788c759ff862a2cb22ba84ccbf072487992f4c2c49ae260f87c7593a1f5f6cf2e45457c76994779a8b30014ee9597e35a2818ca91e33bb7233"
  }
]
