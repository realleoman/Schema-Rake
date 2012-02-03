# encoding: utf-8
require 'fileutils'

namespace :schema do
    desc "Create the  database using the Schema Base"
    task :reset => :environment do
      schema = File.join(RAILS_ROOT, 'db', 'schema.rb')
      schema_base = File.join(RAILS_ROOT, 'db', 'schema_base.rb')
      proceed = true
      if File.exist?(schema_base)
        puts "\n\nSe va a crear la base de datos con el schema original.\n.\n..\n...\n....\n"
        loop do
          print "¿Are you sure? [yes/no]: "
          proceed = STDIN.gets.strip
          break unless proceed.blank?
        end
        proceed = (proceed =~ /y(?:es)*/i)
        if proceed && ActiveRecord::Base.establish_connection(Rails.env)
          if File.exist?(schema)
            FileUtils.rm(schema)
          end
          FileUtils.cp(schema_base, schema)
          Rake::Task["db:drop"].invoke
          Rake::Task["db:create"].invoke
          Rake::Task["db:schema:load"].invoke
          Rake::Task["db:version"].invoke
          puts "Se ha creado la base de datos exitosamente con el schema original."
        end
      else
        puts "No se encuentra el archivo SCHEMA_BASE en la ruta específica"
     end
    end
end
