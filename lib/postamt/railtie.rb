module Postamt
  class Railtie < Rails::Railtie
    railtie_name "postamt"

    initializer "postamt.hook", before: "active_record.initialize_database" do |app|
      # $rails_rake_task was removed in Rails 4, so for Rails 4 we just check if Rake was loaded
      if defined?(Rake) || (defined?($rails_rake_task) && $rails_rake_task)
        # We mustn't hook into AR when db:migrate or db:test:load_schema
        # run, but user-defined Rake tasks still need us
        task_names = []
        tasks_to_examine = Rake.application.top_level_tasks.map{ |task_name| Rake.application[task_name] }
        until tasks_to_examine.empty?
          task = tasks_to_examine.pop
          task_names << task.name
          tasks_to_examine += task.prerequisite_tasks
        end
        next if task_names.any? { |task_name| task_name.start_with? "db:" }
      end
      Postamt.hook!
    end
  end
end
