class Link < ActiveRecord::Base
  validates :url, presence: true, format: {
    with: URI::regexp(%w(http https)),
    message: "is not a URL",
  }
  validates :slug, uniqueness: true, allow_blank: true
  validates :client_ip, presence: true, format: {
    with: Resolv::AddressRegex,
    message: "is not an IP address",
  }

  after_create :set_slug_from_id

  def to_param
    slug
  end

  private

  def set_slug_from_id
    update(slug: id.to_s(36))
  end
end
