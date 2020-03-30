module DatabaseStack
  extend ActiveSupport::Concern
  include Rubycfn

  included do
    include Concerns::GlobalVariables
    include Concerns::SharedMethods
    include DatabaseStack::Database

    description generate_stack_description("DatabaseStack")
  end
end
