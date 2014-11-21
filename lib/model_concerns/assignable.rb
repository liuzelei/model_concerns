module ModelConcerns
  module Assignable
    extend ActiveSupport::Concern

    # usage has :owner, :operator 
    module ClassMethods
      def has(*names)
        names.each do |name|
          belongs_to name, class_name: :User

          scope "filter_by_#{name}", ->(user) { where("#{name}_id = :id or #{name}_no = :no", id: user.id, no: user.no) }

          define_method "assign_#{name}" do |user|
            self.send("#{name}=", user)
            self.send("#{name}_id=", user.id)
            self.send("#{name}_no=", user.no)
          end

          define_method "assign_#{name}!" do |user|
            self.send("assign_#{name}", user)
            self.save(validate: false)
          end
        end
      end
    end
  end
end