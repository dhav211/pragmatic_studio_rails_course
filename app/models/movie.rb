class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user

  RATINGS = %w[G PG PG-13 R NC-17].freeze

  validates :title, :released_on, :duration, :director, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: 'must be a JPG or PNG image'
  }
  validates :rating, inclusion: { in: RATINGS }

  def self.released
    Movie.where(released_on: ..Time.now).order(released_on: :desc)
  end

  def flop?
    (total_gross.blank? || total_gross < 225_000_000) && !cult_classic?
  end

  def cult_classic?
    reviews.size > 50 && reviews.average >= 4
  end

  def reviewed?
    !reviews.empty?
  end
end
