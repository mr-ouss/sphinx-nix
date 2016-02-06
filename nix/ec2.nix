{ account                   # (required) AWS account to deploy to, should be an alias from ~/.ec2-keys
, region ? "us-east-1"      # (optional) AWS region
, zone ? ""                 # (optional) AWS zone
, instanceType ? "t1.micro" # (optional) AWS instsance type
, securityGroup ? null      # (optional) AWS security group
}:
{
  network.description = "Sphnix Docs on Nix" ;

  resources.ec2KeyPairs.keypair = { accessKeyId = account; inherit region; };

  machine = { resources, lib, ... }:
  {
    deployment.targetEnv = "ec2";
    deployment.ec2 = {
      inherit region zone instanceType;
      securityGroups = [ ] ++ lib.optional (securityGroup != null) securityGroup;
      accessKeyId = account;
      keyPair = resources.ec2KeyPairs.keypair.name;
    };
  };
}