class User < ActiveRecord::Base
  has_many :teams

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,  :presence => true, 
                        :uniqueness => true, 
                        :length => {:in => 4..20}, 
                        :format => { 
                          :with => /\A[a-zA-Z]+\z/, 
                          :message => "Only letters (no spaces) allowed" 
                        }

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
end
