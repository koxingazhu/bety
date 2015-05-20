class Format < ActiveRecord::Base
  include Overrides

  extend SimpleSearch
  SEARCH_INCLUDES = %w{ }
  SEARCH_FIELDS = %w{ formats.name formats.mime_type formats.dataformat formats.notes formats.skip formats.header }

  has_many :inputs
  has_many :formats_variables
  has_many :variables, :through => :formats_variables

  # VALIDATION

  ## Validation callbacks

  before_validation WhitespaceNormalizer.new([:name])

  ## Validations

  validates :mime_type,
      presence: true,
      mediatype: true



  scope :sorted_order, lambda { |order| order(order).includes(SEARCH_INCLUDES) }
  scope :search, lambda { |search| where(simple_search(search)) }

  comma do
    id
    name
    mime_type
    dataformat 
    notes
    created_at
    updated_at
  end

  def name_mimetype
    "#{name} #{mime_type}"
  end
  def to_s
    name_mimetype
  end
  def select_default
    "#{id}: #{self}"
  end

  #Columns we search when referenced from another model
  #Fields present in 'select_default'
  def self.search_columns
    return ["formats.id", "formats.name", "formats.mime_type"]
  end
end
