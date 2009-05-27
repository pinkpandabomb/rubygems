require File.join(File.dirname(__FILE__), 'base')

class Thor::Generator
  # Implement the hooks required by Thor::Base.
  #
  class << self
    protected
      def baseclass
        Thor::Generator
      end

      def options_scope
        default_options
      end

      def valid_task?(meth)
        public_instance_methods.include?(meth)
      end

      def create_task(meth)
        tasks[meth.to_s] = Thor::Task.new(meth, nil, nil, nil)
      end
  end

  include Thor::Base

  # Implement specific Thor::Generator logic.
  #
  class << self

    # Start in generators works differently. It invokes all tasks inside the class.
    #
    def start(args=ARGV)
      opts    = Thor::Options.new
      options = opts.parse(args)
      args    = opts.non_opts

      instance = new(options, *args)

      all_tasks.values.map { |task| instance.send(task.name, *args) }
    rescue Thor::Error => e
      $stderr.puts e.message
    end

  end
end
