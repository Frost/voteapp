require "digest/sha1"
require 'net/http'
# TODO: fixa password_confirmation on create
# TODO: fixa möjlighet att byta lösenord. Användare måste förse sitt gamla lösen, admin kan ändra allas (admin borde dock behöva confirma det med hjälp av sitt eget lösen)
class User < ActiveRecord::Base
  has_many :entries
  has_and_belongs_to_many :roles
  has_many :news_comments, :dependent => :delete_all
  
  attr_accessor :password
  
  # validates_uniqueness_of :ticketno
  
  #validates_presence_of :address
  # TODO: lägg till validates_presence_of :email för notifications, när de implementeras
  #validates_presence_of :email 
  
  # ticket number verification is handled by validate_existence_of_identifier
  validate :validate_existence_of_identifier
  
  validate_on_create :validate_uniqueness_except_null
  
  def after_validation
    self.password_hash = User.create_password_hash(self.password)
    
    
    # CHANGED: plockade bort så att den alltid lägger in användare i voter-gruppen. detta får till följd att viss kod i admin/competition/show blir redundant, pga att bara folk med giltiga biljettnummer får rösta.
  end
  
  def after_create
    self.password = nil
  end
  
  def self.login(login, password)
    password_hash = create_password_hash(password)
    find_by_login_and_password_hash(login, password_hash)
  end
  
  def login_try()
    User.login(self.login, self.password)
  end
  
  def to_s
    return self.login
  end
  
  
  
  private
  
  # Antingen
  # login+password + ticketid
  # login+password + crewinfo
  # login+password + sponsorinfo
  # ticketid
  
  def validate_existence_of_identifier
    if self.status == nil and not verify_ticket_number
      errors.add "ticket number", "must be specified"
    elsif self.status.nil? and verify_ticket_number
      return
    else
      # TODO: se till att man inte kan få in en login.nil? till den här koden
      if self.login.nil? or self.login.strip == "" or 
          self.password.nil? or self.password.strip == ""
        errors.add "login and password ", "must be specified"
      else # Nu är vi säkra på att vi har ett giltigt användarnamn och lösenord
        
        # login+password + ticketid case
        # om nån redan tagit biljettnumret
        if self.status == "user" and not verify_ticket_number
          if User.find_by_ticketno(self.ticketno)
            # FIXME: Om en användare redigerar sin info, så kommer ticketnumber valideras igen, och den kommer inte släppa igenom ändringen eftersom den inte kollar om den användaren den hittar med User.find_by_ticketno(self.ticketno) är samma som self. 
            errors.add "ticket number ", "must be unique"
          end
          errors.add "ticket number ", "must be correct"
        elsif self.status == "crew" and self.team.strip == "" and self.cc_nick.strip == "" # login+password + crewinfo
          errors.add "team and crew area nick ", "must be entered"
        elsif self.status == "sponsor" and self.company.strip == "" # login+password + sponsorinfo
          errors.add "sponsor company ", "must be entered"
        end
      end
    end
  end
  
  def validate_uniqueness_except_null
    existing_user = User.find_by_login(self.login)
    # return
    if existing_user
      errors.add "username ", "must be unique"
      return false
    else
      return true
    end
  end
  
  def verify_ticket_number
    # CHANGED: nedanstående kod användes för att verifiera biljettnummer w07
    # använd följande: curl -d biljettnr=PBN1401030262V http://tickets.dreamhack.se/verifyticket.php
    
    logger.info "ticketno = #{self.ticketno}"
    logger.info "status = #{self.status}"
    
    if self.ticketno.nil? or self.ticketno.strip == ""
      return false
    else
      res = Net::HTTP.start('tickets.dreamhack.se') {|http|
        http.post("/verifyticket.php", "biljettnr=#{self.ticketno}")
      }
    
      # kolla om det är ett korrekt biljettnummer som ingen redan har tagit
      if res.body == "TRUE"  and not User.find_by_ticketno(self.ticketno)
        v = Role.find_by_name("voter")
        self.roles << v unless self.roles.include?(v)
        return true
      else
        return false
      end
    end
  end
  
  def self.create_password_hash(password)
    if password.nil?
      return nil
    end
    Digest::SHA1.hexdigest(password)
  end
end