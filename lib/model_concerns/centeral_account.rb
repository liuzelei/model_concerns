# encoding: utf-8
require "openssl"
require "base64"
module CentralAccount
  extend ActiveSupport::Concern

  CREATE_USER_PATH = "#{APP_CONFIG['um_url']}/api/users"
  DESTROY_USER_PATH = "#{APP_CONFIG['um_url']}/api/users/%{id}"
  CA_FILE = "#{Rails.root}/#{APP_CONFIG['um_ca_file']}"

  attr_accessor :password

  included do
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@[^@]+\z/ }
    validates :password, presence: true, confirmation: true, length: { in: 6..20 }, if: :password_required?
    validates :password_confirmation, presence: true, if: :password_required?
  end

  def register(*roles)
    user = Hash.new
    user["username"] = self.username
    user["email"] = self.email
    user["password"] = self.password
    user["roles"] = []
    if roles.length == 0
      user["roles"] << { app_code: APP_CONFIG["app_code"], role: self.role }
    else
      roles.each do |item|
        user["roles"] << { app_code: item[:app_code], role: item[:role] }
      end
    end
    
    uri = URI(CREATE_USER_PATH)
    uri.query = URI.encode_www_form({ app: APP_CONFIG["app_code"], checksum: generate_checksum })
    request = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    request.body = user.to_json
    Rails.logger.debug user.to_json
    Rails.logger.debug request.body
    http = Net::HTTP.new(uri.host, uri.port)
    setup_ssl(http) if "https" == uri.scheme
    response = http.request(request)
    data = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    Rails.logger.debug data
    unless data.nil?
      if "0" == data["code"]
        self.save
      else
        unless data["errors"].nil?
          data["errors"].each do |item|
            self.errors["base"] = item
          end
        end
        self.errors["base"] = data["message"]
        false
      end
    else
      self.errors["base"] = "无法访问注册服务器."
      false
    end
  end

  def lock
    uri = URI(DESTROY_USER_PATH % { id: self.username })
    uri.query = URI.encode_www_form({ app: APP_CONFIG["app_code"], checksum: generate_checksum })
    http = Net::HTTP.new(uri.host, uri.port)
    setup_ssl(http) if "https" == uri.scheme
    request = Net::HTTP::Delete.new(uri)
    response = http.request(request)
    data = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    Rails.logger.debug data
    unless data.nil?
      if "0" == data["code"]
        self.save
      else
        unless data["errors"].nil?
          data["errors"].each do |item|
            self.errors["base"] = item
          end
        end
        self.errors["base"] = data["message"]
        false
      end
    else
      self.errors["base"] = "无法访问注册服务器."
      false
    end
  end

  # roles attribute format like "admin@um,common@dispatcher"
  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :roles
        unless value.blank?
          value.split(',').collect do |setting|
            role, code = setting.split('@')
            self.role = role if code.upcase == APP_CONFIG["app_code"]
          end
        end
      when :email
        self.email = value
      end
    end
  end

  private
  def password_required?
    new_record?
  end

  def generate_checksum
    key = OpenSSL::PKey::RSA.new APP_CONFIG["app_public_key"]
    Base64.encode64(key.public_encrypt(APP_CONFIG["app_code"].upcase))
  end

  def setup_ssl(http)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = CA_FILE
    http.cert_store = OpenSSL::X509::Store.new
    http.cert_store.set_default_paths
  end

end