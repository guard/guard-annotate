# encoding: utf-8
module Guard
  class Annotate
    class Notifier

      class << self
        def guard_message( result, duration )
          case result
          when true
            "Annotate has been run successfully\nin %0.2f seconds." % [duration]
          else
            "Annotate run has failed!\nPlease check manually."
          end
        end

        def guard_image( result )
          result ? :success : :failed
        end

        def notify( result, duration )
          message = guard_message( result, duration )
          image   = guard_image( result )

          Compat::UI.notify( message, :title => 'Annotate complete', :image => image )
        end
      end

    end
  end
end
