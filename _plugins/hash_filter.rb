module Jekyll
  # Remove categories which we don't want on view
  module HashFilter
    RESTRICTED_CATEGORIES = %w(_i18n pl en)

    def hash_filter(hash)
      hash.delete_if { |key, _value| RESTRICTED_CATEGORIES.include? key }
    end
  end
end

Liquid::Template.register_filter(Jekyll::HashFilter)
