module ApplicationHelper
  def users_for_options
    Setting.active.where(group: "user_name").map{|x| [x.value]}.sort
  end
  def ips_for_hash
    Setting.active.where(group: "ips").inject(Hash.new()) { |memo,current | memo[current.value]=current.label; memo }
  end
end
