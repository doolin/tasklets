
namespace :olddb do
  namespace :backup do

    def interesting_tables
      ActiveRecord::Base.connection.tables.sort.reject! do |tbl|
        # This script is from 2006. All of these probably should be 
        # replaced with only 'schema_migrations' for tasklets
        # ['schema_info', 'sessions', 'public_exceptions'].include?(tbl)
        ['schema_migrations'].include?(tbl)
      end
    end

    desc 'Dump entire db.'
    task :write => :environment do 

      dir = './db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)

      interesting_tables.each do |tbl|

        klass = tbl.classify.constantize
        puts "Writing #{tbl}..."
        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }      
      end

    end

    task :read => [:environment, 'db:schema:load'] do 

      dir = './db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)

      interesting_tables.each do |tbl|

        klass = tbl.classify.constantize
        ActiveRecord::Base.transaction do 

          puts "Loading #{tbl}..."
          YAML.load_file("#{tbl}.yml").each do |fixture|
            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(',')}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(',')})", 'Fixture Insert'
          end
        end
      end

    end

  end
end

# gem install aws-s3
# add gem 'aws-s3' to Gemfile, bundle install
# http://devcenter.heroku.com/articles/config-vars
# http://devcenter.heroku.com/articles/s3

#require 'rake/dsl_definition'
require 'rake'
require 'yaml'
# require 'aws/s3'

=begin
BACKUP_BUCKET_NAME = 'tasklets'
APP_NAME = 'tasklets'

# Example: rake backups:backup

#desc "Create a name for the backup file"
def create_name(basename)
  backup_name = Time.now.strftime("%Y%m%d_%H%M%S") + "_#{basename}.dump"
  p "From create_name: ", backup_name
  return backup_name
end


  desc "Dump a postgres database into tmp"
def pgdump(backup_name)
  #puts "backup started @ #{Time.now}"
  #puts "dumping sql file.."
  #backup_name =  "#{APP_NAME}_#{Time.now.to_s(:number)}.sql"
  backup_path = "tmp/#{backup_name}"
  #DB_CONFIG = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'database.yml'))).result)[Rails.env]
  `echo #{DB_CONFIG['password']} | pg_dump #{DB_CONFIG['database']} -Fc --username=#{DB_CONFIG['username']} --host=#{DB_CONFIG['host']} > #{backup_path}`
end


namespace :backups do

  desc "backup from localhost and send to S3"
  #task :backup => :environment do
  #task :backup, :bucketname, :filename do |t, args|
  task :backup do |t|

    puts "From backups:backup..."

    BACKUP_BUCKET_NAME = 'tasklets' #args.bucketname
    #backup_name = create_name(args.filename)
    #pgdump(FILENAME)
    #puts "backup started @ #{Time.now}"
    #puts "dumping sql file.."
    backup_name =  "#{APP_NAME}_#{Time.now.to_s(:number)}.sql"
    backup_path = "tmp/#{backup_name}"
    DB_CONFIG = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'database.yml'))).result)[Rails.env]
    # -Fc is pg_dump "custom" flag.
    `echo #{DB_CONFIG['password']} | pg_dump #{DB_CONFIG['database']} -Fc --username=#{DB_CONFIG['username']} --host=#{DB_CONFIG['host']} > #{backup_path}`
    # -Fp is pg_dump plain text output.
    #`echo #{DB_CONFIG['password']} | pg_dump #{DB_CONFIG['database']} -Fp --username=#{DB_CONFIG['username']} --host=#{DB_CONFIG['host']} > #{backup_path}`

    puts "gzipping sql file..."
    `gzip #{backup_path}`

    backup_name += ".gz"
    puts "We're gzipped..."
    backup_path = "tmp/#{backup_name}"

    puts "Connecting to S3..."
    connect_s3!

    begin
      puts "Finding bucket named ", BACKUP_BUCKET_NAME, "..."
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET_NAME)
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create(BACKUP_BUCKET_NAME)
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET_NAME)
    end

    puts "uploading #{backup_name} to S3..."

    AWS::S3::S3Object.store(backup_name, File.open(backup_path,"r"), bucket.name, :content_type => 'application/x-gzip')
    #`rm -rf #{backup_path}`
    puts "backup completed @ #{Time.now}"

  end

  desc "Extract the database configuration"
  task :getdbconfig do
    #DB_CONFIG = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'database.yml'))).result)[RAILS_ENV]
    DB_CONFIG = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'database.yml'))).result)[Rails.env]
    puts DB_CONFIG
  end

end


def connect_s3!
  AWS::S3::Base.establish_connection!(
    :access_key_id     => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET']
  )
  #puts ENV['S3_KEY']
end



namespace :perez do

  desc "backup db from heroku and send to S3"
  # $ rake backups:backup['tasklets','tasklets']
  task :backup => :environment do

    APP_NAME = 'tasklets' # put your app name here
    BACKUP_BUCKET = 'tasklets' # put your backup bucket name here
    DB_CONFIG = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'database.yml'))).result)[RAILS_ENV]

    puts "backup started @ #{Time.now}"

    puts "dumping sql file..."

    backup_name =  "#{Time.now.to_s(:number)}_#{APP_NAME}.dump"
    backup_path = "tmp/#{backup_name}"

    #`echo #{DB_CONFIG['password']} | pg_dump #{DB_CONFIG['database']} -Fc --username=#{DB_CONFIG['username']} --host=#{DB_CONFIG['host']} > #{backup_path}`
    # Assumes PGPASSWORD is set, check DB_CONFIG.
    `pg_dump #{DB_CONFIG['database']} -Fc --username=#{DB_CONFIG['username']} --host=#{DB_CONFIG['host']} > #{backup_path}`

    puts "gzipping sql file..."
    `gzip #{backup_path}`

    backup_name += ".gz"
    backup_path = "tmp/#{backup_name}"

    puts "connecting to S..."
      AWS::S3::Base.establish_connection!(
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
        )

#=begin
    begin
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET)
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create(BACKUP_BUCKET)
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET)
    end

    puts "uploading #{backup_name} to S3..."

    AWS::S3::S3Object.store(backup_name, File.open(backup_path,"r"), bucket.name, :content_type => 'application/x-gzip')
    `rm -rf #{backup_path}`
    puts "backup completed @ #{Time.now}"
#=end

 end

end
=end
