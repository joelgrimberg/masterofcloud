module DatabaseStack
    module Database
      extend ActiveSupport::Concern
      included do
        parameter :dbname,
                  default: "myAwesomeDatabase",
                  description: "my fucking awesome database"
        parameter :engine_type,
                  default: "MySQL"
        parameter :dballocatedstorage,
                  default: "50"
        parameter :subnets,
                  description: "Subnets for the Database"

        resource :dbsubnetgroup,
                  type: "AWS::RDS::DBSubnetGroup" do |r|
          r.property(:DBSubnetGroupDescription) {"subnetgroup for DB"}
          r.property(:DBSubnetGroupName) {"dbsubnetgroup"}
          r.property(:SubnetIds) {:subnets.ref.fnsplit(",")}
                  end

        resource :mydatabase,
                  type: "AWS::RDS::DBInstance" do |r|
          r.property(:DBName) {:dbname.ref}
          r.property(:DBInstanceClass) {"db.t2.micro"}
          r.property(:DBSubnetGroupName) {"dbsubnetgroup"}
          r.property(:Engine) {:engine_type.ref}
          r.property(:MasterUsername) { ENV["DB_Username"] }
          r.property(:MasterUserPassword) { ENV["DB_Password"] }
          r.property(:AllocatedStorage) {:dballocatedstorage.ref}
          r.property(:PubliclyAccessible) { true }
          r.property(:DBSnapshotIdentifier) { ENV["SNAPSHOTID"]}
                  end

                end

              end

            end
