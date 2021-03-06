module Svgeez
  module Commands
    class Watch < Command
      def self.init_with_program(program)
        program.command(:watch) do |command|
          command.description 'Watches a folder of SVG icons for changes'
          command.syntax 'watch [options]'

          add_build_options(command)

          command.action do |_, options|
            Build.process(options)
            Watch.process(options)
          end
        end
      end

      def self.process(options)
        builder = Svgeez::Builder.new(options)

        listener = Listen.to(builder.source.folder_path, only: /\.svg\z/) do
          builder.build
        end

        Svgeez.logger.info "Watching `#{builder.source.folder_path}` for changes... Press ctrl-c to stop."

        listener.start
        sleep
      rescue Interrupt
        Svgeez.logger.info 'Quitting svgeez...'
      end
    end
  end
end
