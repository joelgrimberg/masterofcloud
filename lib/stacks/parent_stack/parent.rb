require_relative "../../core/applications"

module InfraStack
  module Parent
    extend ActiveSupport::Concern
    included do
      generate_bootstrap_parameters

      resource :vpc_stack,
               type: "AWS::CloudFormation::Stack" do |r|
        r.property(:template_url) { "vpcstack" }
        r.property(:tags) { default_tags }
      end

      resource :database_stack,
               type: "AWS::CloudFormation::Stack" do |r|
        r.property(:template_url) { "databasestack" }
        r.property(:parameters)
        {
          "Subnets": [
            :vpc_stack.ref("Outputs.BackendRdsPublicSubnetName"),
            :vpc_stack.ref("Outputs.BackendRdsPublicSubnet2Name"),
            :vpc_stack.ref("Outputs.BackendRdsPublicSubnet3Name"),
          ].fnjoin(","),
        }
      end

      resource :acm_stack,
               amount: 0,
               type: "AWS::CloudFormation::Stack" do |r|
        r.property(:template_url) { "acmstack" }
        r.property(:tags) { default_tags }
      end

      resource :ecs_stack,
               amount: 0,
               type: "AWS::CloudFormation::Stack" do |r|
        r.depends_on %w(VpcStack)
        r.property(:template_url) { "ecsstack" }
        r.property(:parameters) do
          {
            "Vpc": "VpcStack".ref("Outputs.VpcId"),
            "Subnets": [
              :vpc_stack.ref("Outputs.Ec2PrivateSubnetName"),
              :vpc_stack.ref("Outputs.Ec2PrivateSubnet2Name"),
              :vpc_stack.ref("Outputs.Ec2PrivateSubnet3Name"),
            ].fnjoin(","),
            "PublicSubnets": [
              :vpc_stack.ref("Outputs.Ec2PublicSubnetName"),
              :vpc_stack.ref("Outputs.Ec2PublicSubnet2Name"),
              :vpc_stack.ref("Outputs.Ec2PublicSubnet3Name"),
            ].fnjoin(","),
          }
        end
      end

      create_applications
    end
  end
end
