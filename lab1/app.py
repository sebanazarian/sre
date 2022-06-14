from aws_cdk import (
    aws_ec2 as ec2,
    aws_iam as iam,
    App, Stack
)
from constructs import Construct

class EC2InstanceStack(Stack):
    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)
        
        # vpc = ec2.Vpc.from_lookup(self, "VPC",is_default=True)

        vpc = ec2.Vpc(
            self,
            "VPC",
            nat_gateways=0,
            subnet_configuration=[
                ec2.SubnetConfiguration(name="public", subnet_type=ec2.SubnetType.PUBLIC)
            ],
        )
        amzn_linux = ec2.MachineImage.latest_amazon_linux(
            generation=ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
            edition=ec2.AmazonLinuxEdition.STANDARD,
            virtualization=ec2.AmazonLinuxVirt.HVM,
            storage=ec2.AmazonLinuxStorage.GENERAL_PURPOSE,
        )
        
        http =ec2.SecurityGroup(self, 'http', vpc=vpc, security_group_name='htt_sg')
        https = ec2.SecurityGroup(self, 'https', vpc=vpc, security_group_name='htts_sg')
        ssh = ec2.SecurityGroup(self, 'ssh', vpc=vpc, security_group_name='ssh_sg')
        
        http.add_ingress_rule(
            ec2.Peer.any_ipv4(), #0.0.0.0/0
            connection=ec2.Port.tcp(80),
            description="allow traffic from anywhere thru the port 80"
        )
        
        https.add_ingress_rule(
            ec2.Peer.any_ipv4(), #0.0.0.0/0
            connection=ec2.Port.tcp(443),
            description="allow traffic from anywhere thru the port 443"
        )
        
        ssh.add_ingress_rule(
            ec2.Peer.any_ipv4(), #0.0.0.0/0
            connection=ec2.Port.tcp(22),
            description="allow traffic from anywhere thru the port 22"
        )
        # Instance
        prod = ec2.Instance(
            self,
            "instance",
            instance_type=ec2.InstanceType("t2.micro"),
            machine_image=amzn_linux,
            vpc=vpc,
        )

app = App()
EC2InstanceStack(app, "ec2-instance")

app.synth()