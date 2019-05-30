{ account                   # (required) AWS account to deploy to, should be an alias from ~/.ec2-keys
, accountId                 # (required) AWS account ID
, vpcId                     # (required) AWS VPC ID
, region ? "us-east-1"      # (optional) AWS region
, subnetId ? ""
, zone ? ""                 # (optional) AWS zone
, instanceType ? "t3.micro" # (optional) AWS instsance type
, securityGroup ? null      # (optional) AWS security group
}:
{
  network.description = "Sphnix Docs on Nix" ;

  resources.ec2KeyPairs.keypair = { accessKeyId = account; inherit region; };

  resources.ec2SecurityGroups.sg = { resources, lib, ... }:
  {
    inherit region vpcId;
    accessKeyId = account;
    description = "Security group for Sphinx Docs on Nix";
    rules = [
      { toPort = 22; fromPort = 22; sourceGroup = { ownerId = accountId; groupName = resources.ec2SecurityGroups.sg.name; }; }
      { toPort = 443; fromPort = 443; sourceIp = "0.0.0.0/0"; }
      { toPort = 80; fromPort = 80; sourceIp = "0.0.0.0/0"; }
    ];
  };

  machine = { resources, lib, ... }:
  let
    secGroups = [ "default" resources.ec2SecurityGroups.sg.name ];
  in
  {
    deployment.targetEnv = "ec2";
    deployment.storeKeysOnMachine = false;
    deployment.ec2 = {
      inherit region zone instanceType;
      subnetId = subnetId;
      securityGroups = if (subnetId == "") then secGroups else [];
      securityGroupIds = if (subnetId != "") then secGroups else [];
      accessKeyId = account;
      keyPair = resources.ec2KeyPairs.keypair.name;
    };
  };
}