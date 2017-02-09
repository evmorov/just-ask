module MailHelpers
  def wait_for_email_for(user, timeout = 10)
    start_time = Time.now
    while Time.now - start_time < timeout
      sleep 0.5
      next if all_emails.size.zero?
      return if all_emails.map(&:to).flatten.include? user.email
    end

    raise "No emails for #{user.email} after #{timeout} seconds"
  end
end
