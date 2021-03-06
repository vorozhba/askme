require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_\-]+\z/
  VALID_EMAIL_REGEX = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i
  VALID_CSS_COLOR_REGEX = /\#([a-f0-9]{6}|[a-f0-9]{3})$\Z/i

  attr_accessor :password
  # ��� ����-��-������; 㤠�塞 ������, ������� ���짮��⥫�, �� 㤠����� ���짮��⥫�
  # http://rusrails.ru/active-record-associations#dependent3
  has_many :questions, dependent: :destroy

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :username, length: { maximum: 40 },
            format: { with: VALID_USERNAME_REGEX }
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :color, format: { with: VALID_CSS_COLOR_REGEX }

  validates :password, presence: true, on: :create

  validates_confirmation_of :password

  before_validation :username_downcase
  before_save :encrypt_password

  def username_downcase
    username.downcase! unless username.nil?
  end

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(
              password, password_salt, ITERATIONS, DIGEST.length, DIGEST
          )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
            password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
    )

    return user if user.password_hash == hashed_password

    nil
  end
end
