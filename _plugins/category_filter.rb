module Jekyll
  # Remove categories which we don't want on view
  module CategoryFilter
    RESTRICTED_CATEGORIES = %w(_i18n pl en)

    def categories_filter(categories)
      filtered = []
      categories.each do |category|
        filtered.push(category) unless RESTRICTED_CATEGORIES.include? category
      end
      filtered.sort.uniq
    end
  end
end

Liquid::Template.register_filter(Jekyll::CategoryFilter)
