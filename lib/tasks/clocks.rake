namespace :timesheet do
  desc "send_timesheet_by_date"
  task :send_mail => [:environment] do
    AdminMailer.timesheet(Date.today).deliver
  end
end
