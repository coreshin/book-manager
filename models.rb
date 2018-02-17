require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
    has_secure_password
    validates :name,
        presence: true,
        uniqueness: true
    validates :password,
        length: { minimum: 5 },
        on: :create
    validates :password,
        length: { minimum: 5 },
        allow_blank: true,
        on: :update
    has_many :books
    has_many :lists
end

class Book < ActiveRecord::Base
    scope :had_by, -> (user) { where(user_id: user.id) }
    
    validates :title,
        presence: true
    validates :rate,
        length: { in: 1..5 }
    belongs_to :user
    belongs_to :list
end

class List < ActiveRecord::Base
    scope :had_by, -> (user) { where(user_id: user.id) }
    has_many :books
    belongs_to :user
end