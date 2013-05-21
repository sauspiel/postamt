module Postamt
  class Railtie < Rails::Railtie
    railtie_name "postamt"

    attr_accessor :running_in_rake
    rake_tasks do
      self.running_in_rake = true
    end

    initializer "postamt.hook", before: "active_record.initialize_database" do |app|
      if self.running_in_rake
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
