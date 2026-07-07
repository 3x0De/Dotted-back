require 'sequel'
require 'logger'
require 'fileutils'


FileUtils.mkdir_p('log')

log_file = File.open('log/Dot.log', 'a')
log_file.sync = true

DB = Sequel.connect(ENV['DATABASE_URL'], logger: Logger.new(log_file))

Sequel.extension :pg_array_ops
DB.extension :pg_array