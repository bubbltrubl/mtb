class User < ActiveRecord::Base
  has_many :teams
  has_many :authentications

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
  
  def image_url
    return current_auth.image_url unless current_auth.nil?
    return nil
  end
  
  def current_auth
    possible_auths = possible_auths_for_image
    return nil if possible_auths.empty?
    current = possible_auths.select { |auth| auth.use_as_picture == true }.first
    current = possible_auths.first if current.nil?
    return current
  end

  def possible_auths_for_image
    return authentications.select { |auth| !auth.image_url.nil? }
  end
end
