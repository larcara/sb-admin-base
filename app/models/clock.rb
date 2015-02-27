#encoding: UTF-8
class Clock < ActiveRecord::Base
  validates_presence_of  :action
  validates_presence_of  :date
  validates_presence_of  :time
  validates_presence_of  :ip
  validates_presence_of  :user

  attr_accessor :pin

  validate :check_time_and_status
  validate :check_ip
  validates_length_of :message, minimum: 10, allow_nil: true, allow_blank: true, message: "Verificare la motivazione (troppo corta)"

  def check_ip
    last_check_in=Clock.where(date: self.date, ip: self.ip).first
    if last_check_in.nil?
      return true
    elsif last_check_in.user == self.user
      return true
    elsif  message.blank?
      self.errors.add(:base, "Questo indirizzo IP risulta già utilizzato da #{last_check_in.user}. E' necessario specificare una motivazione")
      return false
    end
  end

  def  check_time_and_status
    last_check_in=Clock.where(user: self.user, date: self.date, action: "check_in").first
    last_check_out=Clock.where(user: self.user, date: self.date, action: "check_out").first
    if action=="check_in" && last_check_in
      self.errors.add(:base, "L'utente ha gia effettuato il check in alle #{last_check_in.time}")
      return false
    end
    if action=="check_out" && last_check_out
      self.errors.add(:base, "L'utente ha gia effettuato il check out alle #{last_check_out.time}")
      return false
    end

    if Setting.where(group: "user_name",key: self.pin, value: self.user).first.nil?
      self.errors.add(:base, "il pin non è corretto")
      return false
    end

    delta = (Time.now - self.time).to_i / 60
    if delta.abs > 6 && message.blank?
      self.errors.add(:base, "Differenza #{delta} minuti - Per differenze maggiori di 5 minuti è necessario indicare una motivazione")
      return false
    end

  end

  def to_s
    "#{self.user} ha effettuato #{self.action} alle ore #{self.time.to_s} - Note: #{self.message}"
  end
end
