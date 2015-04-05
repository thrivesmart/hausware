class Location < ActiveRecord::Base
  has_many :spaces
  
  before_validation :autofill_permalink_if_blank
  
  validates :permalink, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9\-_]+\Z/ }
  validates :timezone, presence: true
  
  def autofill_permalink_if_blank
    return true unless self.permalink.blank? # Bypass if permalink is already set
    self.permalink = AutoPermalink::cleaned_deduped_permalink(self.class, self.name)
  end

  def to_param
    self.permalink
  end
  
  def earliest_opening
    [self.sunday_opening, self.monday_opening, self.tuesday_opening, self.wednesday_opening, self.thursday_opening, self.friday_opening, self.saturday_opening].min
  end
  
  def latest_closing
    [self.sunday_closing, self.monday_closing, self.tuesday_closing, self.wednesday_closing, self.thursday_closing, self.friday_closing, self.saturday_closing].max
  end
  
end
