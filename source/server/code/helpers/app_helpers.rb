require_relative 'diff_avatar_image'
require_relative 'diff_traffic_light'
require_relative 'gatherer'
require_relative 'parity'
require_relative 'pie_chart'
require_relative 'time_tick'
require_relative 'traffic_light_count'
require_relative '../models/group'
require_relative '../models/katas'

module AppHelpers

  def group
    @group ||= Group.new(externals, params)
  end

  def katas
    @katas ||= Katas.new(externals, params)
  end

  def time
    externals.time
  end

end
