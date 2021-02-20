require 'redis'

Redis.current = Redis.new(url:  ENV['HELPEXCHANGE_REDIS_URL'],
                          port: ENV['HELPEXCHANGE_REDIS_PORT'],
                          db:   ENV['HELPEXCHANGE_REDIS_DB'])