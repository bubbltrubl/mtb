class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,  :presence => true, 
                        :uniqueness => true, 
                        :length => {:in => 4..20}, 
                        :format => { 
                          :with => /\A[a-zA-Z]+\z/, 
                          :message => "Only letters (no spaces) allowed" 
                        }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
end
