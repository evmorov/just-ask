# Learn more: http://github.com/javan/whenever

every 1.day, at: '1pm' do
  runner 'DailyDigestJob.perform_later'
end

every 60.minutes do
  rake 'ts:index'
end
