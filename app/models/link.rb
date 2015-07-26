class Link < ActiveRecord::Base
  validates :url, :client_ip, presence: true
  validates :slug, uniqueness: true, allow_blank: true
  after_create :set_slug_from_id

  def to_param
    slug
  end

  private

  def set_slug_from_id
    update(slug: id.to_s(36))
  end
end
