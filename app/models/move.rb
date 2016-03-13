class Move
  include ActiveModel::Model

  attr_accessor :x_pos, :y_pos, :player

  validates :x_pos, presence: true
  validates :y_pos, presence: true
  validates :player, presence: true

  def as_json(options={})
    super(only: ["x_pos", "y_pos", "player"])
  end
end
