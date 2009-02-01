require 'digest/sha1'
class User < ActiveRecord::Base

  has_and_belongs_to_many :groups, :join_table=>"groups_users"
  has_many :set_teacher_links
  has_many :pupil_sets, :through=>:set_teacher_links, :order=>"set_code", :conditions=>"set_teacher_link.end_date IS NULL"
  has_and_belongs_to_many :guidance_groups, :order=>"code"
  belongs_to :faculty
  has_many :positives
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login #, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
 # validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :case_sensitive => false
  before_save :encrypt_password

  def fullname
    self.title.to_s + " " + self.firstname.to_s[0,1] + " " +  self.lastname.to_s
  end

  def current_pupil_sets(session_id=SchoolSession.current.id)
    self.pupil_sets.find(:all, :conditions=>"school_session_id=#{session_id} AND end_date IS NULL") rescue nil
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def edit_password(password, password_confirmation)
    if password==password_confirmation
      self.password=password
      self.save
    end
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
