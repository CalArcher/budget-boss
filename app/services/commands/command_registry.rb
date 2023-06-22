module Commands
  class CommandRegistry
    @registry = {}

 
    class << self
      def register(command_name, klass)
        @registry[command_name] = klass
      end

      def find_command_class(command_name)
        @registry[command_name]
      end

      def list_registered_commands
        @registry
      end
    end
  end
end

