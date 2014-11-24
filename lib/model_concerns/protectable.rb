require "model_concerns/string"
require "base64"

module ModelConcerns
  module Protectable
    extend ActiveSupport::Concern

    def fake_id
      return nil if self.id.nil?
      @fake_id ||= Base64.encode64(self.id.to_s ^ self.class.xor_key).gsub(/\n/, '')
    end

    module ClassMethods
      def xor_key
        @xor_key ||= Digest::MD5.hexdigest(name)
      end

      def find_by_fake_id(fake_id)
        return find_by_id(find_id_by_fake_id(fake_id))
      end

      def find_id_by_fake_id(fake_id)
        return (Base64.decode64(fake_id) ^ xor_key).to_i
      end

      def protectable?
        true
      end
    end
  end
end