require "model_concerns/string"

module ModelConcerns
  module Protectable
    extend ActiveSupport::Concern

    def fake_id
      return nil if self.id.nil?
      @fake_id ||= self.id.to_s ^ self.class.xor_key
    end

    module ClassMethods
      def xor_key
        @xor_key ||= Digest::MD5.hexdigest(name.underscore)
      end

      def find_by_fake_id(fake_id)
        real_id = fake_id ^ xor_key
        return find_by_id(real_id)
      end

      def find_id_by_fake_id(fake_id)
        return (fake_id ^ xor_key).to_i
      end
    end
  end
end