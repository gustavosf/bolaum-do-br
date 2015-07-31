class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :name, :photo, :password

  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :photo
  validates_presence_of :password, :on => :create

  validates_uniqueness_of :email

  has_many :bets
  has_many :standings
  has_many :league_teams

  default_scope :order => 'id ASC'

  def self.generate_api_key
    loop do
      api_key = SecureRandom.base64.tr('+/=', 'Qrt')
      break api_key unless User.exists?(api_key: api_key)
    end
  end

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
end