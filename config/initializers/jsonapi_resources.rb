JSONAPI.configure do |config|
  # :none, :offset, :paged, or a custom paginator name
  config.default_paginator = :paged

  # Output pagination links at top level
  config.top_level_links_include_pagination = true

  # Default sizes
  config.default_page_size = 20
  config.maximum_page_size = 100

  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :total_count
end
