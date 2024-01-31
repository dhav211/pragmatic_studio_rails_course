class Movie < ApplicationRecord
  before_save :set_slug
  before_save :format_email

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  RATINGS = %w[G PG PG-13 R NC-17].freeze

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, :director, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: 'must be a JPG or PNG image'
  }
  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where(released_on: ..Time.now).order(released_on: :desc) }
  scope :upcoming, -> { where(released_on: Time.now..).order(released_on: :asc) }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { released.where('total_gross > 300000000').order(total_gross: :asc) }
  scope :flops, -> { released.where('total_gross < 225000000').order(total_gross: :asc) }
  scope :grossed_less_than, ->(amount) { released.where(total_gross: ..amount).order(total_gross: :asc) }

  def flop?
    (total_gross.blank? || total_gross < 225_000_000) && !cult_classic?
  end

  def cult_classic?
    reviews.size > 50 && reviews.average >= 4
  end

  def reviewed?
    !reviews.empty?
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end

  def format_email
    email.downcase
  end
end
