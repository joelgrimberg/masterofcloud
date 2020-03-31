module DatabaseStack
  module Database
    extend ActiveSupport::Concern
    included do
      parameter :engine_type,
                default: "MySQL"
      parameter :db_allocated_storage,
                default: "50"
      parameter :subnets,
                description: "Subnets for the Database"

      resource :db_subnet_group,
               type: "AWS::RDS::DBSubnetGroup" do |r|
        r.property(:db_subnet_groupname) { "db_subnet_group" }
        r.property(:db_subnet_groupdescription) { "subnetgroup for DB" }
        r.property(:subnet_ids) { :subnets.ref.fnsplit(",") }
      end

      resource :my_database,
               type: "AWS::RDS::DBInstance" do |r|
        r.property(:db_instance_class) { "db.t2.micro" }
        r.property(:db_subnet_groupname) { :db_subnet_group.ref }
        r.property(:engine) { :engine_type.ref }
        r.property(:master_username) { ENV["DB_Username"] }
        r.property(:master_userpassword) { ENV["DB_Password"] }
        r.property(:allocated_storage) { :db_allocated_storage.ref }
        r.property(:publicly_accessible) { true }
        r.property(:db_snapshot_identifier) { ENV["SNAPSHOTID"] }
      end
    end
  end
end
