# encoding: utf-8
require 'guard'
require 'guard/guard'

module Guard
  class Annotate < Guard

    autoload :Notifier, 'guard/annotate/notifier'

    def initialize( watchers=[], options={} )
      super

      options[:notify] = true if options[:notify].nil?
      options[:position] = 'before' if options[:position].nil?
      options[:tests] = false if options[:tests].nil?
      options[:routes] = false if options[:routes].nil?
      options[:run_at_start] = true if options[:run_at_start].nil?
      options[:show_indexes] = false if options[:show_indexes].nil?
    end

    def start
      run_annotate if options[:run_at_start]
    end

    def stop
      true
    end

    def reload
      run_annotate if options[:run_at_start]
    end

    def run_all
      true
    end

    def run_on_change( paths=[] )
      run_annotate
    end

    private

    def notify?
      !!options[:notify]
    end

    def annotation_position
      options[:position]
    end

    def annotate_routes?
      options[:routes]
    end

    def annotate_tests_flags
      options[:tests] ? "" : "--exclude tests,fixtures"
    end

    def show_indexes?
      options[:show_indexes]
    end

    def run_annotate
      UI.info 'Running annotate', :reset => true
      started_at = Time.now
      annotate_models_command = "bundle exec annotate #{annotate_tests_flags} -p #{annotation_position}"
      annotate_models_command += " --show-indexes" if show_indexes?
      @result = system(annotate_models_command)
      Notifier::notify( @result, Time.now - started_at ) if notify?

      if annotate_routes?
        started_at = Time.now
        @result = system("bundle exec annotate -r -p #{annotation_position}")
        Notifier::notify( @result, Time.now - started_at ) if notify?
      end

      @result
    end
  end
end
