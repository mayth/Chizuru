require './user_stream'

us = Chizuru::UserStream.new('credential.yaml', 'meitanbot', 'cert', 'meitanbot/2.0 (Chizuru/1.0)')
us.connect do |json|
  p json
end
