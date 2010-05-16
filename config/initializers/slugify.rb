class String
  def slugify( params = { } )
    # Load YAML file from RAILS_ROOT/config
    begin
      trans_table = YAML.load_file("#{RAILS_ROOT}/config/trans_table.yml")
    rescue
      # Fall back to the default file
      trans_table = YAML.load_file(Pathname.new(__FILE__).dirname.to_s + "/trans_table.yml")
    end
    # Set default parameters
    if params.is_a?(Hash)
      locales = params[:locales]
      spacer = params[:spacer]
    elsif params.is_a?(Array)
      locales = params
    elsif params.is_a?(String)
      # If `params` is a 1-character string, we assume it's a spacer,
      # otherwise, it's a locale code.
      if params.length == 1
        spacer = params
      else
        locales = params
      end
    end
    # We make sure something is set after all
    locales ||= trans_table.keys.reverse
    spacer ||= "-"
    # We use reverse order of locales by default, so that the first locales
    # defined in YAML file take precedence in case of conflicting definitions.
    transpairs = { }
    if locales.respond_to? "each"
      locales.each do |locale|
          if trans_table[locale]
            trans_table[locale].each do |char, translit|
              transpairs[char] = translit
            end
          end
      end
    else
      transpairs = trans_table[locale]
    end
    str = self.mb_chars.downcase
    # Discard unneeded characters
    str.gsub!(/[!?-_,'";#$\%&=+*<>\(\)\[\]{}\\\/\|]/, "")
    # Replace special marks with text
    # str.gsub!(/®/, "registered")
    # str.gsub!(/@/, "at")
    # str.gsub!(/©/, "copyright")
    # Transliterate and clean up
    str.each_char.map {|c| transpairs[c] || c }.join.gsub(/[\W_]+/, spacer).gsub(/^[\W_]|[\W_]$/, "")
  end
  alias :to_slug :slugify
end