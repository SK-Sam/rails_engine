class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.handle_pagination(per_page=20, page=1)
    page_adjustments = handle_sad_inputs(per_page, page)
    limit = page_adjustments[:per_page]
    offset = page_adjustments[:per_page] * (page_adjustments[:page] - 1)
    all.limit(limit).offset(offset)
  end

  def self.handle_sad_inputs(per_page, page)
    per_page = 20 if per_page == nil || per_page > 20 || per_page < 1
    page = 1 if page == nil || page < 2
    { per_page: per_page, page: page }
  end
end
