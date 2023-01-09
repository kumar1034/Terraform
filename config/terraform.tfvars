region = "us-east-1"
access_key = "AKIASWBPTMJF4PGG2JP3"
secret_key = "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"

vpc_config  = {

    testing_project_vpc = {

        vpc_cidr_block = "192.168.0.0/16"

        tags = {
            "Name" = "testing_project_vpc"
        }

    }

}

subnet_config  = {

    "public-us-east-1a" = {

        vpc_name = "testing_project_vpc"
        cidr_block = "192.168.1.0/24"
        availability_zone = "us-east-1a"
        
        tags = {
            "Name" = "public-us-east-1a"
        }   

    }

    "public-us-east-1b" = {

        vpc_name = "testing_project_vpc"
        cidr_block = "192.168.2.0/24"
        availability_zone = "us-east-1b"
        
        tags = {
            "Name" = "public-us-east-1b"
        }   

    }

    "private-us-east-1a" = {

        vpc_name = "testing_project_vpc"
        cidr_block = "192.168.3.0/24"
        availability_zone = "us-east-1a"
        
        tags = {
            "Name" = "private-us-east-1a"
        }   

    }

    "private-us-east-1b" = {

        vpc_name = "testing_project_vpc"
        cidr_block = "192.168.4.0/24"
        availability_zone = "us-east-1b"
        
        tags = {
            "Name" = "private-us-east-1b"
        }   

    }

}


internetGW_config = {

    igw01 = {
        vpc_name = "testing_project_vpc"

        tags ={
            "Name" = "testing_project-IGW1"
        }
    }

}

elasticIP_config = {

    eip01 = {

        tags = {
            "Name" = "nat01"
        }
        
    }

    eip02 = {

        tags = {
            "Name" = "nat02"
        }
        
    }
}

natGW_config = {

    natGW01 = {
        eip_name = "eip01"

        subnet_name = "public-us-east-1a"

        tags = {

            "Name" = "natGW01"
        }
    }

    natGW02 = {
        eip_name = "eip02"

        subnet_name = "public-us-east-1b"

        tags = {
            
            "Name" = "natGW02"
        }
    }

}

route_table_config = {

    rt_config_01 = {
        private = 0
        vpc_name = "testing_project_vpc"
        gateway_name = "igw01"

        tags = {
            "Name" = "Public-route"
        }

    }

    rt_config_02 = {
        private = 1
        vpc_name = "testing_project_vpc"
        gateway_name = "natGW01"

        tags = {
            "Name" = "private-route"
        }

    }

    rt_config_03 = {
        private = 1
        vpc_name = "testing_project_vpc"
        gateway_name = "natGW02"

        tags = {
            "Name" = "private-route"
        }

    }

}

route_table_association_config = {

    RTAssoc_01 = {
        subnet_name = "public-us-east-1a"
        route_table_name = "rt_config_01"
    }

     RTAssoc_02 = {
        subnet_name = "public-us-east-1b"
        route_table_name = "rt_config_01"
    }

     RTAssoc_03 = {
        subnet_name = "private-us-east-1a"
        route_table_name = "rt_config_02"
    }

     RTAssoc_04 = {
        subnet_name = "private-us-east-1b"
        route_table_name = "rt_config_03"
    }

}
