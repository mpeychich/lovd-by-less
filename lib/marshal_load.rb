module Marshal
  class <<self
    def load_with_preload_class(str, &p)
      str.scan(/[.\n\t\r]*o:[.\n\t\r]([\w:]+)/).each{|matches|
        begin
          # by constantizing the class name,
          # it should trigger it to be autoloaded.
          matches.first.constantize
        rescue NameError
          # I guess that wasn't a class we found after all.
          # Nothing to see here, move along
        end
      }
      load_without_preload_class(str, &p)
    end
    alias_method_chain :load, :preload_class
  end
end
