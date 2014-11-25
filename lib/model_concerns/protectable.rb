module ModelConcerns
  module Protectable
    extend ActiveSupport::Concern

    def fake_id
      return nil if self.id.nil?
      @fake_id ||= self.id ^ self.class.protect_seed
    end

    def to_param
      fake_id.to_s
    end

    def reload(options = nil)
      options = (options || {}).merge(real_id: true)
      super(options)
    end

    module ClassMethods

      def find(*args)
        scope = args.slice!(0)
        options = args.slice!(0) || {}
        if protectable? && !options[:real_id]
          if scope.is_a?(Array)
            scope.map! {|a| find_id_by_fake_id(a).to_i}
          else
            scope = find_id_by_fake_id(scope)
          end
        end
        super(scope)
      end

      def protect_seed
        alphabet = Array("a".."z") 
        number = name.split("").collect do |char|
          alphabet.index(char)
        end
        @protect_seed ||= number.shift(12).join.to_i
      end

      def find_by_fake_id(fake_id)
        find_by_id(find_id_by_fake_id(fake_id.to_i))
      end

      def find_id_by_fake_id(fake_id)
        fake_id.to_i ^ protect_seed
      end

      def protectable?
        true
      end
    end
  end
end