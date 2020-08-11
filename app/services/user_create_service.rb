class UserCreateService
  attr_reader :full_name, :document, :address, :birthday, :gender, :password

  def initialize(full_name:, document:, address:, birthday:, gender:, password:)
    @full_name = full_name
    @document = document
    @address = address
    @birthday = birthday
    @gender = gender
    @password = password
  end

  def self.create(...)
    new(...).create
  end

  def create
    create_user_and_account
  end

  private

  def create_user_and_account
    ActiveRecord::Base.transaction do
      user ||= User.new(
        full_name: full_name,
        document: document,
        address: address,
        birthday: birthday,
        gender: gender,
        password: password,
        token: token
      )

      create_account(user) if user.valid?

      user
    end
  end

  def token
    @token ||= SecureRandom.hex
  end

  def create_account(user)
    AccountCreateService.create(user)
  end
end
