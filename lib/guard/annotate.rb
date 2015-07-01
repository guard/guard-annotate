# encoding: utf-8
require 'guard/compat/plugin'
require 'guard/annotate/version'

module Guard
  class Annotate < Plugin

    autoload :Notifier, 'guard/annotate/notifier'

    def initialize(options={})
      super

      options[:notify] = true if options[:notify].nil?
      options[:position] = 'before' if options[:position].nil?
      options[:tests] = false if options[:tests].nil?
      options[:factories] = true if options[:factories].nil?
      options[:serializers] = true if options[:serializers].nil?
      options[:sort] = false if options[:sort].nil?
      options[:routes] = false if options[:routes].nil?
      options[:run_at_start] = true if options[:run_at_start].nil?
      options[:show_indexes] = false if options[:show_indexes].nil?
      options[:simple_indexes] = false if options[:simple_indexes].nil?
      options[:show_foreign_keys] = false if options[:show_foreign_keys].nil?
      options[:show_migration] = false if options[:show_migration].nil?
      options[:format] = nil if options[:format].nil? or not [:bare, :markdown, :rdoc].include? options[:format].to_sym
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

    def run_on_changes(paths=[])
      run_annotate
    end
    alias :run_on_change :run_on_changes if ::Guard::AnnotateVersion::VERSION < '1.1.0'

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

    def annotate_excludes
      excludes = []
      excludes << 'tests' << 'fixtures' unless options[:tests]
      excludes << 'factories' unless options[:factories]
      excludes << 'serializers' unless options[:serializers]

      excludes.empty? ? '' : "--exclude #{excludes.join(',')}"
    end

    def annotate_sort_columns?
      options[:sort]
    end

    def show_indexes?
      options[:show_indexes]
    end

    def annotate_format
      options[:format]
    end

    def annotate_format?
      not options[:format].nil?
    end

    def simple_indexes?
      options[:simple_indexes]
    end

    def show_migration?
      options[:show_migration]
    end
    
    def show_foreign_keys?
      options[:show_foreign_keys]
    end

    def run_annotate
      Compat::UI.info 'Running annotate', :reset => true
      started_at = Time.now
      annotate_models_options, annotate_options = '', ''

      annotate_models_command = "bundle exec annotate #{annotate_excludes} -p #{annotation_position}"
      annotate_models_options += ' --sort' if annotate_sort_columns?
      annotate_models_options += ' --show-indexes' if show_indexes?
      annotate_models_options += ' --simple-indexes' if simple_indexes?
      annotate_models_options += ' --show-migration' if show_migration?
      annotate_models_options += ' --show-foreign-keys' if show_foreign_keys?
      annotate_options += " --format=#{annotate_format}" if annotate_format?

      annotate_models_command += annotate_models_options + annotate_options
      @result = system(annotate_models_command)
      Notifier::notify(@result, Time.now - started_at) if notify?

      if annotate_routes?
        started_at = Time.now
        position = if %w[after before].include? options[:routes].to_s
          options[:routes]
        else
          annotation_position
        end
        annotate_routes_command = "bundle exec annotate -r -p #{position}"

        annotate_routes_command += annotate_options
        @result = system(annotate_routes_command)
        Notifier::notify(@result, Time.now - started_at) if notify?
      end

      @result
    end
  end
end
